namespace :duoleshi do
	desc "多乐士联系人修改"
  task :paint_contact => :environment  do
    paint_contacts = PaintContact.find(:all, :conditions => "contact_name like '%多乐士%'")
    p "*"*10
    paint_contacts.each do |f|
      p f.id
      f.update_attributes(:contact_name => f.contact_name.gsub(/多乐士/,"1家1"))
    end
    p '*'*10
  end
end



