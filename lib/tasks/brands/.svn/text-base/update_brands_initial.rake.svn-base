namespace :brands do
  desc 'update brands nil initial'
  task :update_brands_initial => :environment do

    time = Time.now
    Brand.find(:all, :conditions => ['initial is null or initial = ?', '']).each do |brand|
      p brand.name_zh
      unless brand.name_zh.blank?
        first_name = brand.name_zh.mb_chars.first.to_s
        if first_name =~ /^[a-zA-Z]/
          brand.update_attribute :initial, first_name.downcase
        else 
          en_name = ChineseDictionary.pinyin_for(first_name)
          unless en_name.blank?
            brand.update_attribute :initial, en_name.first
          else
            p "#{brand.id} : CH :  词库中无法识别 ===========================================  [#{first_name}]  "
          end
        end
      end
    end
    p "cost :   #{Time.now - time} ms " 
 end
end
