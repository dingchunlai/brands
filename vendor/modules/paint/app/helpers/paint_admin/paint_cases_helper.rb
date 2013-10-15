module PaintAdmin::PaintCasesHelper
  
  #判断木器漆是否有其它
  def is_other_wood_paint paint_cases
    unless paint_cases.new_record? || paint_cases.wood_paint.blank?
      YAML.load(paint_cases.wood_paint) - PaintCase::WOOD_PAINT
    end
  end 
  
  #判断木器漆是否被选中
  def is_wood_paint(product ,paint_cases)
    if paint_cases.new_record? || paint_cases.wood_paint.blank?
      false
    else
      (YAML.load(paint_cases.wood_paint).include? product) ? true : false
    end 
  end
  
  def renovation_is_other paint_cases
    if paint_cases.new_record?
      {:result => false, :this_value => ""} 
    else
      (PaintCase::RENOVATION.include? paint_cases.renovation) ? {:result => false, :this_value => ""} : {:result => true, :this_value => paint_cases.renovation}
    end
  end
  
end
