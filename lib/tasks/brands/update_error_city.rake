namespace :brands do
  desc 'update agency promotion_article error city'
  task :update_error_city => :environment do

    # 经销商
    Agency.all.each do |agency|
      if agency.city.unpack('c*').any? { |char| char < 0 }
        p "CH : #{agency.city}"
        if agency.city == '全国'
          agency.update_attribute :city, 'quanguo'
        else
          obj = City.find_by_name(agency.city)
          unless obj.blank?
            agency.update_attribute :city, obj.pinyin
          end
        end
      end
    end
 
  end
end
