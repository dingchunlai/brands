desc "为案例日记表导记录"
task :add_cases_and_diaries_table =>:environment  do
  diaries = DecorationDiary.find(:all,:select =>"id,created_at,order_time,updated_at",:conditions => ["status = 1"])
  p "diaries size #{diaries.size}"
  cases = HejiaCase.find(:all,:select => "ID,CREATEDATE",:conditions => ["COMPANYID is not null and STATUS <> '-100' and STATUS <> '-50'"])
  p " cases size #{cases.size}"
  
  diaries.each_with_index do |diary,index|
    p "#{index} : create as diary id = #{diary.id}"
    cad = CaseAndDiary.new
    cad.item_id = diary.id
    cad.item_type = 'DecorationDiary'
    cad.order_time = diary.order_time.blank? ? diary.updated_at : diary.order_time
    cad.created_at = diary.created_at
    cad.updated_at = diary.updated_at
    cad.save
  end
  cases.each_with_index do |c,index|
    p "#{index} : create as case id = #{c.ID}"
    cad = CaseAndDiary.new
    cad.item_id = c.ID
    cad.item_type = 'HejiaCase'
    cad.order_time = c.CREATEDATE
    cad.created_at = c.CREATEDATE
    cad.updated_at = c.CREATEDATE
    cad.save
  end 
  
end