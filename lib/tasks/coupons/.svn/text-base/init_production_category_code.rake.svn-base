namespace :coupon do
  desc 'initialize model serializble code'
  task :initialize_production_category_code => :environment do

   # update_code
    ProductionCategory.all.each do |pc|
      unless pc.tag.blank?
        pc.update_attribute :code, pc.next_success
      end
    end

  end
end
