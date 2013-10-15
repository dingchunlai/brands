namespace :coupon do
  desc '抵用券推广位'
  task :spread_position_city => :environment do
    if ENV['CITY']
      city = City.find_by_pinyin(ENV['CITY'])
      PromotionCollection.find(:all, :conditions => ["code like ?", '%:shanghai:%']).each do |item|

        PromotionCollection.create!(
            :name      => item.name.gsub("上海", "#{city.name}"),
            :code      => item.code.gsub("shanghai", "#{city.pinyin}"),
            :item_type => 'GeneralResource',
            :size      => item.size,
            :remark    => item.remark
        )
      puts "#{item.id} duplicated ok."
      end
    else
      puts "ENV parameter CITY is missing."
    end
  end
end
