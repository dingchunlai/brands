desc "去掉表数据里的前后空格(源数据是xls导的)"
task :update_relate_tag_value =>:environment  do
  all = RelateTag.find(:all)
  p "update size #{all.size}"
  p " ********* star ************* "
  all.each do |r|
    r.update_attributes(:article_tag => r.article_tag.to_s.strip , :diary_tag => r.diary_tag.to_s.strip)
  end
  p " ****** end ******** "
end