module PaintAdmin::PaintWorkersHelper
  
  #学历,职业,知道方式 是否为其它
  def info_is_other paint_worker
    if paint_worker.id.nil?
       education_other = job_other = know_other = {:result => false, :this_value => ""} 
    else
      education_other = (Painter::EDUCATION.include? paint_worker.painter.education) ? {:result => false, :this_value => ""} : {:result => true, :this_value => paint_worker.painter.education}
      job_other = (Painter::JOBS.include? paint_worker.painter.job) ? {:result => false, :this_value => ""} : {:result => true, :this_value => paint_worker.painter.job} 
      know_other = (Painter::KNOW_HERE.include? paint_worker.painter.know_here) ? {:result => false, :this_value => ""} : {:result => true, :this_value => paint_worker.painter.know_here}
    end
    {
      :education => education_other,
      :job => job_other,
      :know_here => know_other
    }
  end
  
  #判断试用产品是否被选中
  def is_trial(product , trial_products)
      if trial_products.blank?
        false
      else
        (YAML.load(trial_products).include? product) ? true : false
      end 
  end
  
   #判断试用产品是否有其它
   def is_trial_other(paint_worker)
     unless paint_worker.id.nil? || paint_worker.painter.trial_products.blank?
       YAML.load(paint_worker.painter.trial_products) - Painter::TRIAL_PRODUCTS
     end
   end
   
   #得到油工省份
  def get_paint_worker_province
    provinces = Painter.get_province.by_status(1)
    province_array = []
    provinces.each do |code|
      province_array << [Province.name_for_code(code.province), code.province]
    end
    province_array
  end
  
  #得到省份下的城市城市
  def get_paint_worker_cities province
    Painter.cities_for_province province  
  end
   
end 
