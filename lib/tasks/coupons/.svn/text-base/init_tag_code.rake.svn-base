namespace :coupon do
  desc "initialize Tag model code "
  task :initialize_tag_code => :environment do
    Tag.all_categories.each do |tag|
	tag.code = tag.next_success
	tag.save
    end
 
 end
end
