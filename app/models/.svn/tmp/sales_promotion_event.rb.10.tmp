class SalesPromotionEvent < ActiveRecord::Base

  include Hejia::Promotable
  include CloudFsHelper

  promotion_method_alias :title, :subject
  promotion_method_alias :description, :html_description
  promotion_method_alias :content, :content
  promotion_method_alias :url, :url

  belongs_to :event_type, :class_name => 'SalesPromotionEventType' # 活动类型
  has_and_belongs_to_many :tags, :join_table => 'product.sales_promotion_events_tags'
  has_and_belongs_to_many :brands

  validates_presence_of :subject
  validate :validate_city

  serialize :location_latlng

  def validate_city
    if self.city == "全国" || self.city == "quanguo"
      write_attribute(:city, 'quanguo')
    else
      obj = City.find_by_pinyin(self.city)
      unless obj.blank?
        write_attribute(:city, obj.pinyin)
      else
        obj = City.find_by_name(self.city)
        unless obj.blank?
          write_attribute(:city, obj.pinyin)
        else
          errors.add('城市输入错误  正确格式: [上海|shanghai]')
        end
      end
    end
  end

  #未到期的活动
  named_scope :unexpired, {
    :conditions => ["ends_at >= ?", Time.zone.now],
    :order => "ends_at asc"
  }

  #已到期的活动
  named_scope :expired, {
    :conditions => ["ends_at < ?", Time.zone.now],
    :order => "ends_at desc"
  }

  #根据品类编号tag_id限制
  named_scope :for_tag, lambda { |tag_id|
    tag_id = tag_id.TAGID if tag_id.is_a?(Tag)
    {
      :joins => 'JOIN sales_promotion_events_tags ON sales_promotion_events.id = sales_promotion_events_tags.sales_promotion_event_id',
      :conditions => (['sales_promotion_events_tags.tag_id = ?', tag_id])
    }
  }

  #根据城市限制
  named_scope :for_city, lambda { |city_code|
    {
      :conditions => ["city = ?", city_code]
    }
  }

  #进行中的活动
  named_scope :underway, {
    :conditions => ["begins_at <= ? && ends_at >= ?", Time.zone.now, Time.zone.now]
  }

  #未开始的活动
  named_scope :unstart, {
    :conditions => ["begins_at > ?", Time.zone.now],
    :order => "begins_at asc"
  }
  
  class << self

    #获取活动，对未到期和已到期的活动按不同的排序逻辑
    #优先取得未到期的活动
    def get_events(limit=32,tag_id=0,city='none')
      unexpired_events = SalesPromotionEvent.unexpired
      unexpired_events = unexpired_events.for_tag(tag_id) if tag_id.to_i > 0
      unexpired_events = unexpired_events.find(:all, :limit => limit)
      expired_events = []
      if unexpired_events.length < limit
        #如果未到期的活动数不够，从已到期的活动里提取凑数
        expired_events = SalesPromotionEvent.expired
        expired_events = expired_events.for_tag(tag_id) if tag_id.to_i > 0
        expired_events = expired_events.find(:all, :limit => limit - unexpired_events.length)
      end
      return unexpired_events.concat(expired_events)
    end

    #活动总数
    def all_events_counter
      SalesPromotionEvent.count("id")
    end

    #正在进行的活动数
    def underway_events_counter
      SalesPromotionEvent.count("id", :conditions => ["begins_at <= ? && ends_at >= ?", Time.zone.now, Time.zone.now])
    end
    
    #拥有活动的城市
    def has_events_cities(limit)
      max_limit = 40
      fail "limit参数值不能大于#{max_limit}" if limit > max_limit
      memkey = "memkey_has_events_cities_#{max_limit}"
      cities = Rails.cache.fetch(memkey, 2.hours) do
        SalesPromotionEvent.find(:all,:select => 'city, count(city) as count',
          :conditions => ["city <> ''"], :group => 'city', :order => 'count desc', :limit => max_limit)
      end
      cities[0...limit]
    end
  
  end

  #活动时间
  def duration
    time = begins_at.strftime("%Y年%m月%d日 %H:%M").sub(' 00:00','')
    time += (" - " + ends_at.strftime("%Y年%m月%d日 %H:%M").sub(' 00:00','')) unless ends_at.blank?
  end

  #活动短标题
  def short_subject
    read_attribute("short_subject").blank? ? subject : read_attribute("short_subject")
  end

  #取得图片
  def image(thumbnail=nil)
    cloud_fs_url_for(image_url, :thumbnail => thumbnail)
  end

  def image_url
    img = read_attribute("image_url")
    img = "/4c529c5f86869732810000b7-ce4c2db6284b270d73f9509a55e3ed68.jpg" if img.blank?
    img
  end

  def cityname
    c = City.with_pinyin(city)
    city_name = (c.blank? ? '上海' : c.name)
    city_name
  end

  def short_begins_at
    begins_at.strftime("%m月%d日") rescue "-月-日"
  end

  def title_link(target="_blank")
    "<a href='#{url}' title='#{subject}' target='#{target}'>#{subject}</a>"
  end

  def location
    str = read_attribute("location")
    str = "请联系组织方确认活动地点" if str.blank?
    str
  end

  def update_location_latlng
    update_attribute :location_latlng, GoogleMapAPI.geocode(location)
  end

  #活动终端页url
  def url
    "http://www.51hejia.com/huodong/#{id}"
  end

  #取得该活动的第一个品类tag_id
  def first_tag
    @first_tag = tags[0] if @first_tag.nil?
    @first_tag
  end

  #下一个活动
  def next_event_link
    link = ""
    event = SalesPromotionEvent.find(:first,:select => "id,subject",:conditions=>["id > ?", id])
    unless event.nil?
      link = "<a href='#{event.url}' target='_self' title='#{event.subject}'>#{event.subject}</a>"
    end
    return link
  end

end
