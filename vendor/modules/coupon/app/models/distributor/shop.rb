class Distributor::Shop < ActiveRecord::Base
  include CloudFsHelper
  
  before_save :fetch_mapinfo

  belongs_to :distributor, :counter_cache => true
  belongs_to :city
  has_many :coupons
  
  validates_presence_of :name, :city_id, :district_id, :telphone
  validates_format_of :city_id, :district_id, :with => /^[1-9]\d*$/
  validates_format_of :business_zone_id, :with => /^[1-9]\d*$/, :unless => Proc.new { |shop| shop.business_zone_id.blank?  }
  validates_format_of :telphone, :with => /(^(\d{2,4}[-_－—]?)?\d{3,8}([-_－—]?\d{3,8})?([-_－—]?\d{1,7})?$)|(^0?1[35]\d{9}$)/

  default_scope :conditions => 'deleted = 0', :order => 'id desc'
  
  named_scope :by_distributor, lambda { |distributor_id|
    { :conditions => ["distributor_id = ?" , distributor_id] }
  }

  named_scope :by_city, lambda { |city_id|
    { :conditions => ["city_id = ?" , city_id] }
  }

  named_scope :by_district, lambda { |district_id|
    { :conditions => ["district_id = ?" , district_id] }
  }

  named_scope :like_name, lambda { |str|
    if str.blank?
      {}
    else
      { :conditions => ["name like ?", "#{str}%"] }
    end
  }

  class << self

    def record_by_id(id)
      if id.to_i > 0
        Distributor::Shop.first(:select => 'id, name', :conditions => ['id = ?', id])
      else
        nil
      end
    end

    def id_to_name(object)
      object = record_by_id(object) if object.class != self
      return '' if object.nil?
      object.name
    end

    #创建测试数据
    def create_test_data
      if RAILS_ENV == 'development'
        1.upto(99) do
          Distributor::Shop.create(
            :name => "测试店铺记录#{rand(999)+99}",
            :distributor_id => rand(6) + 1)
        end
      else
        fail '只能在开发环境创建测试数据！'
      end
    end

    #创建搜索对象
    def new_search(attrs, distributor_id = 0)
      self.new( (attrs || {}).merge(:distributor_id => distributor_id) )
    end
    
    # 参数distributor_ids 为某业务员下的经销商 或者 经销商
    def valid_count(distributor_ids = nil)
      unless distributor_ids.blank?
        if distributor_ids.is_a?(Array)
          Distributor::Shop.count('id', :conditions => ["distributor_id in (?)", distributor_ids])
        else
          Distributor::Shop.count('id')
        end
      else
        Distributor::Shop.count('id')
      end
    end

  end

  def city_name
    City.id_to_name(city_id)
  end

  def district
    District.id_to_name(district_id)
  end

  def district_options
    if city_id.to_i > 0
      District.by_city(city_id).map{|d| [d.name,d.id]}.unshift(['请选择',''])
    else
      [['请先选择城市', '']]
    end
  end

  def business_zone
    BusinessZone.id_to_name(business_zone_id)
  end

  def market_shop
    MarketShop.id_to_name(market_shop_id)
  end

  #返回搜索结果
  def searh
    if distributor_id.to_i == 0
      shops = Distributor::Shop
    else
      shops = Distributor::Shop.by_distributor(distributor_id)
    end
    shops = shops.like_name(name) unless name.blank?
    shops = shops.by_city(city_id) if city_id.to_i > 0
    shops = shops.by_district(district_id) if district_id.to_i > 0
    shops
  end

  def mark_deleted
    write_attribute('deleted', true)
    if save
      Distributor.decrement_counter(:shops_count, distributor_id)
      coupons.each do |coupon|
        coupon.mark_deleted
      end
    end
  end
  
  private
  def fetch_mapinfo
    if self.new_record?
      update_mapinfo(self)
    else
      if self.address_changed?
        update_mapinfo(self)
      end
    end
  end


  def update_mapinfo(shop)
    begin
      city_name = City.find(shop.city_id).name
      district_name = District.find(shop.district_id).name
      addr = "#{city_name}#{district_name}#{shop.address}"
      lat_lng = GoogleMapAPI.geocode(addr)
      if lat_lng.is_a?(Array)
        shop.latitude = lat_lng[0]
        shop.longitude = lat_lng[1]
        content_type = {
          'png' => 'image/png',
          'jpg' => 'image/jpeg',
          'gif' => 'image/gif'
        }
        format = 'png'
        map_img_url = GoogleMapAPI.show_static_map(lat_lng[0], lat_lng[1], :format => format)
        img_response = HttpRequest.get(map_img_url)
        response = HttpRequest.post(
                :url => cloud_fs_upload_path("image"),
                :files => {
                        :file_name     => 'map.png',
                        :field_name    => 'file',
                        :content_type  => content_type['png'],
                        :file_content  => img_response.body
                }
        )
        doc = Nokogiri::XML(response.body)
        if doc.root.name == "response" # success response
          id = doc.xpath("//id").text
          md5 = doc.xpath("//md5").text
          shop.googlemap_image_url = "#{id}-#{md5}.#{format}"
        end
      end
    rescue
      
    end
  end

end
