# 品类
# 使用HEJIA_TAG中“品牌库”的子标签作为品类使用。
class Industry < Hejia::Db::Hejia
  set_table_name 'HEJIA_TAG'
  set_primary_key 'TAGID'

  include HejiaCouponSerializable
  hejia_set_serialization ('a'..'z').to_a.concat((0..9).to_a)

  def serialization_key
    'hejia:coupon:tag:code'
  end

  has_and_belongs_to_many :sales_promotion_events
  has_one :bbs_tag, :foreign_key => "brand_tag_id"
  has_many :production_categories, :class_name => 'ProductionCategory', :primary_key => 'TAGID', :foreign_key => 'tag_id', :dependent => :destroy

  named_scope :for_production_category_id, lambda { |production_category|
    tag = production_category.class==ProductionCategory ? production_category.tag : ProductionCategory.find(production_category).tag
    tag_id = tag ? tag.TAGID : 0
    { :conditions => ["TAGID = ?", tag_id]}
  }

  named_scope :for_brand, lambda{ |brand|
    brand_id = brand.class==Brand ? brand.id : brand
    tag_ids = TaggedBrand.find(:all, :select => 'tag_id', :conditions => ['brand_id = ?', brand_id]).map{|r| r.tag_id}
    { :conditions => ["TAGID in (?)", tag_ids]}
  }

  def serial_key
    'hejia:coupon:tag:code'
  end

 # named_scope :get_case_id, lambda {|keyword|{ :select=>"TAGID" , :conditions => ["TAGESTATE='0' and TAGTYPE='case' and TAGNAME = ? ",keyword }}


  def self.get_case_id keyword
    self.find(:first,:select=>"TAGID",:conditions => ["TAGESTATE='0' and TAGTYPE='case' and TAGNAME = ? ",keyword] ).TAGID rescue 0
  end

  def self.get_tagname(tag_id)
    return nil if tag_id.to_i == 0
    tag = HejiaTag.find(:first,:select=>"TAGNAME",:conditions=>"TAGID = #{tag_id} and TAGESTATE='0' and TAGTYPE = 'case'")
    if tag.nil?
      return nil
    else
      return tag["TAGNAME"]
    end
  end


  class << self
    # 品类页面中，各个特殊栏目获取所属文章的方法。
    # 由于文章的获取没有规律可言，所以只能把各种情况都分别列出，再按照情况分别根据自己的查找方法来查。
    def find_article_methods
      @find_article_methods ||= {
        '地板' => {
          '文章列表1' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39161 AND HEJIA_ARTICLE.SECONDCATEGORY = 39166 AND HEJIA_ARTICLE.THIRDCATEGORY = 39174',
            :limit => 6
          },
          '文章列表2' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39161 AND HEJIA_ARTICLE.SECONDCATEGORY = 39166 AND HEJIA_ARTICLE.THIRDCATEGORY = 39175',
            :limit => 6
          },
          '文章列表3' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39161 AND HEJIA_ARTICLE.SECONDCATEGORY = 39166 AND HEJIA_ARTICLE.THIRDCATEGORY = 39176',
            :limit => 6
          },
          '术语'      => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39161 AND HEJIA_ARTICLE.SECONDCATEGORY = 39163',
            :limit => 8
          },
          '最新文章'  => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39161', :limit => 8
          }
        },

        '厨房电器' => {
          '文章列表1' => lambda {
            HejiaIndex.find_by_keyword '燃气灶', :select => 'title, url', :limit => 6
          },
          '文章列表2' => lambda {
            HejiaIndex.find_by_keyword '油烟机', :select => 'title, url', :limit => 6
          },
          '文章列表3' => lambda {
            HejiaIndex.find_by_keyword '消毒柜', :select => 'title, url', :limit => 6
          },
          '术语'      => lambda {
            Hejia::Promotion.items API_PROMOTION_MAPPING['品类']['厨房电器']['术语'], :limit => 8
          },
          '最新文章'  => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 31779 AND HEJIA_ARTICLE.SECONDCATEGORY = 38563 AND HEJIA_ARTICLE.THIRDCATEGORY = 38564',
            :limit => 8
          }
        },

        '橱柜/厨具' => {
          '文章列表1' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38721 AND HEJIA_ARTICLE.SECONDCATEGORY = 38722',
            :limit => 6
          },
          '文章列表2' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38721 AND HEJIA_ARTICLE.SECONDCATEGORY = 38723',
            :limit => 6
          },
          '文章列表3' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38721 AND HEJIA_ARTICLE.SECONDCATEGORY = 38724',
            :limit => 6
          },
          '术语'      => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38721 AND HEJIA_ARTICLE.SECONDCATEGORY = 38736',
            :limit => 8
          },
          '最新文章'  => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38721', :limit => 8
          }
        },

        '卫浴洁具' => {
          '文章列表1' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38081 AND HEJIA_ARTICLE.SECONDCATEGORY = 38123 AND HEJIA_ARTICLE.THIRDCATEGORY = 39923',
            :limit => 6
          },
          '文章列表2' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38081 AND HEJIA_ARTICLE.SECONDCATEGORY = 38123 AND HEJIA_ARTICLE.THIRDCATEGORY = 39926',
            :limit => 6
          },
          '文章列表3' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38081 AND HEJIA_ARTICLE.SECONDCATEGORY = 38123 AND HEJIA_ARTICLE.THIRDCATEGORY = 39927',
            :limit => 6
          },
          '术语'      => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38081 AND HEJIA_ARTICLE.SECONDCATEGORY = 38132',
            :limit => 8
          },
          '最新文章'  => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 38081', :limit => 8
          }
        },

        '油漆涂料' => {
          '文章列表1' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39188 AND HEJIA_ARTICLE.SECONDCATEGORY = 39193',
            :limit => 6
          },
          '文章列表2' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39188 AND HEJIA_ARTICLE.SECONDCATEGORY = 39195',
            :limit => 6
          },
          '文章列表3' => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39188 AND HEJIA_ARTICLE.SECONDCATEGORY = 39196',
            :limit => 6
          },
          '术语'      => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39188 AND HEJIA_ARTICLE.SECONDCATEGORY = 39190',
            :limit => 8
          },
          '最新文章'  => {
            :conditions => 'HEJIA_ARTICLE.FIRSTCATEGORY = 39188', :limit => 8
          }
        },

        '吊顶' => {
          '文章列表1' => lambda {
            HejiaIndex.find_by_keyword '集成吊顶', :select => 'title, url', :limit => 6
          },
          '文章列表2' => lambda {
            HejiaIndex.find_by_keyword '石膏板吊顶', :select => 'title, url', :limit => 6
          },
          '文章列表3' => lambda {
            HejiaIndex.find_by_keyword 'pvc吊顶', :select => 'title, url', :limit => 6
          },
          '术语'      => lambda {
            HejiaIndex.find_by_keyword '卫生间吊顶', :select => 'title, url', :limit => 15
          },
          '最新文章'  => lambda {
            HejiaIndex.find_by_keyword '厨房吊顶', :select => 'title, url, description', :limit => 15
          }
        }
      }
    end

    # 取得指定tagurl的品类
    def [](tagurl)
      categories.first :conditions => ['TAGURL = ?', tagurl]
    end

    # 取得指定名称的品类，包括正在使用的和已经停用的。
    # @param [String] name 品类名称，模糊匹配。若不指定，则找出所有的。
    def all_categories(name = nil)
      condition_sql = sanitize_sql_array ['link.TAGID1 = ?', father_id]
      condition_sql << " AND %s" % sanitize_sql_array(['TAGNAME like ?', "%#{name}%"]) unless name.blank?
      Industry.find_by_sql "SELECT `HEJIA_TAG`.* FROM `HEJIA_TAG` JOIN HEJIA_TAGLINK as link on HEJIA_TAG.TAGID = link.TAGID2 WHERE ((TAGESTATE = '0' OR TAGESTATE = '1') AND #{condition_sql}) ORDER BY priority DESC"
    end

    # 取得指定id的品类，包括正在使用和已经停用的。
    # @param [Integer] id 品类的id
    def find_category(id)
      condition_sql = sanitize_sql_array ['link.TAGID1 = ? AND TAGID = ?', father_id, id]
      Industry.find_by_sql("SELECT `HEJIA_TAG`.* FROM `HEJIA_TAG` JOIN HEJIA_TAGLINK as link on HEJIA_TAG.TAGID = link.TAGID2 WHERE ((TAGESTATE = '0' OR TAGESTATE = '1') AND #{condition_sql}) LIMIT 1").first
    end

    #取得已经启用的品类
    def used_categories
      #Tag.categories.find(:all, :select=>"TAGID,TAGNAME,TAGURL", :conditions=>["TAGNAME not in (?)", LINK_URLS['尚未开通品类'].keys])
      Industry.categories.find(:all, :select=>"TAGID,TAGNAME,TAGURL", :conditions=>["TAGESTATE = '0'"], :order => 'priority DESC')
    end

    def get_tagid_by_tagurl(tagurl)
      Industry.categories.find_by_TAGURL(tagurl).TAGID rescue 0
    end

    def get_tagid_by_tagname(tagname)
      Industry.categories.find_by_TAGNAME(tagname).TAGID rescue 0
    end

    def get_tagname_by_tagid(tagid)
      Industry.categories.find_by_TAGID(tagid).TAGNAME rescue ""
    end

    def select_options
      Industry.used_categories.map{ |t| [t.TAGNAME, t.TAGID] }
    end

    def categories_size
      memkey = "Tag:categories:size"
      Rails.cache.fetch(memkey, :expires_in => 1.day) do
        Industry.all_categories.size
      end
    end

  end

  #品牌库的tag id，所有品类都是以这个作为父类的。由于这个id不太可能发生变化，所以可以预先读进来。
  cattr_accessor :father_id
  self.father_id =
    begin
    # “品牌库”这个标签是属于一个叫“3.0资讯分类1级”的父标签，该父标签的TAGCODE是“ZiXun3.0Class1”，这里的查询以TAGCODE为依据。这段逻辑是从radmin项目中的ArticleTag这个model里面整理出来的，不过在该model中，是写死id的（14025）。
    root_id = first(:select => :TAGID, :conditions => ['TAGCODE = ?', 'ZiXun3.0Class1']).TAGID
    first(:select => :TAGID, :conditions => ['TAGFATHERID = ? AND TAGNAME = ?', root_id, '品牌库']).TAGID
    rescue
    end



  cattr_accessor :status_chinese_name_mapping
  self.status_chinese_name_mapping = {'0' => '启用中', '1' => '已停用'}.freeze

  # 取得所有启用的“品类”。
  named_scope :categories, :joins => 'JOIN HEJIA_TAGLINK as link on HEJIA_TAG.TAGID = link.TAGID2',
    :conditions => ['link.TAGID1 = ?', father_id]

  # 取得某一品类下的所有品牌
  def brands
    Brand.of_tag(self.TAGID)
  end

  # 品类状态的中文名称
  def status_zh
    self.class.status_chinese_name_mapping[self.TAGESTATE]
  end

  def enabled?
    self.TAGESTATE == '0'
  end

  # 启用品类
  def enable!
    self.update_attribute :TAGESTATE, '0'
  end

  # 停用品类
  def disable!
    self.update_attribute :TAGESTATE, '1'
  end

  # 删除品类
  def delete!
    self.update_attribute :TAGESTATE, '2'
  end

  # 找出品类下的某一种文章。
  # @param [String] article_type 文章的类型，取值范围：文章列表1，文章列表2，文章列表3，术语，最新文章。
  def find_articles(article_type)
    meth = self.class.find_article_methods[self.TAGNAME][article_type]
    case meth
    when Hash
      Article.all meth
    when Proc
      meth.call
    else
      []
    end
  end

  def bbs_tag_id
    @bbs_tag_id = BbsTag.find(:first, :select=>'id', :conditions=>["brand_id is null and brand_tag_id = ?", read_attribute("TAGID")]).try('id') || 0 if @bbs_tag_id.nil?
    @bbs_tag_id
  end

end
