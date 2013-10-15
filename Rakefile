# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Dir["#{RAILS_ROOT}/vendor/modules/*/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

namespace :brands do
  namespace :db do
    desc "把品牌和品牌信息的关系又一对一变为一对多的关系。"
    task :migrate_brands => :environment do
      require 'brands/db/brand_details_migration'
      Brands::DB::BrandDetailsMigration.instance.run!
    end

    desc "把品牌和品牌评价信息的关系又一对一变为一对多的关系。"
    task :migrate_ratings => :environment do
      require 'brands/db/brand_ratings_migration'
      Brands::DB::BrandRatingsMigration.instance.run!
    end
    
    desc "将文章标识为组合案例的文章信息导入到新的组合案例表中。"
    task :migrate_combinations => :environment do
      require 'brands/db/article_combinations_migration'
      Brands::DB::ArticleCombinationsMigration.instance.run!
    end
    
    desc "将原有评论所存贮品类编号替换为新的品类编号值。"
    task :migrate_comments => :environment do
      require 'brands/db/brand_comments_migration'
      Brands::DB::BrandCommentsMigration.instance.run!
    end

    namespace :sales_events do
      desc '更新促销活动的活动地址经纬度。'
      task :update_latlng => :environment do
        SalesPromotionEvent.class_eval do
          with_exclusive_scope do
            #SalesPromotionEvent.all(:conditions => {:location_latlng => nil}).each { |event| event.update_location_latlng }
            SalesPromotionEvent.all(:conditions => 'location_latlng is null and id > 7').each { |event| event.update_location_latlng }
          end
        end
      end
    end

    desc '加载品牌的关注度数据。'
    task :load_ratings => :environment do 
      if ENV['DATA'].blank?
        puts "[usage] rake brands:db:load_ratings DATA=file_path/data.yml"
      else
        Brands::DB::LoadRatings.load_data_form_yml(File.read(ENV['DATA']))
      end
    end

    desc '加载品牌评论数据。'
    task :brand_comments => :environment do 
      if ENV['DATA'].blank?
        puts "[usage] rake brands:db:brand_comments: DATA=file_path/data.yml"
      else
        Brands::DB::BrandComments.load_data_form_yml(File.read(ENV['DATA']), ENV['IS_GOOD'])
      end
    end
    
    desc '加载品牌印象数据。'
    task :brand_impressions => :environment do 
      if ENV['DATA'].blank?
        puts "[usage] rake brands:db:brand_impressions: DATA=file_path/data.yml"
      else
        Brands::DB::BrandImpressions.load_data_form_yml(File.read(ENV['DATA']))
      end
    end

    desc "为某些品牌添加推广的信息只code"
    task :brand_promotion_code => :environment do
      require 'brands/db/brand_promotion_code'
      Brands::DB::BrandPromotionCode.instance.run!
    end
 
    desc "为某些品牌添加投票数据"
    task :brand_votes => :environment do
      require 'brands/db/brand_votes'
      Brands::DB::BrandVotes.load_data_form_yml(File.read(ENV['DATA']))
    end
 
    desc '处理品牌上月关注度问题。'
    task :brand_attentions => :environment do 
      require 'brands/db/brand_attentions'
      Brands::DB::BrandAttentions.instance.run!(ENV['force'])
    end 
    
    desc '误将总PV存贮为上月PV值 现做修改'
    task :update_brand_rank => :environment do 
      require 'brands/db/update_brand_rank'
      Brands::DB::UpdateBrandRank.instance.run!
    end 

    desc '将现有品牌的html_meta信息导入数据库  TIME: 2010-09-17'
    task :load_brand_html_metadata => :environment do 
      if ENV['DATA'].blank?
        puts "[usage] rake brands:db:load_brand_html_metadata DATA=file_path/html_meta.yml"
      else
        Brands::DB::BrandHtmlMeta.load_data_form_yml(File.read(ENV['DATA']))
      end
    end

    desc '实例化创建品类首页的推广位信息 params AS tag_name, category_name, brand_name'
    task :create_category_promotion => :environment do 
      if ENV['TAG'].blank? || ENV['CATEGORY'].blank? || ENV['BRAND'].blank?
        puts "[usage] rake brands:db:create_category_promotion TAG=xx CATEGORY=xx BRAND=XX "
      else
        Brands::DB::CreateCategoryPromotion.filter_params(ENV['TAG'], ENV['CATEGORY'], ENV['BRAND'])
      end
    end

  end
end
