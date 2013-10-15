namespace :coupon do
  desc "validate print properties for image generate"
  task :validate_imagen_properties => :environment do
    Coupon.all(:conditions => ['activity_end_at >= ?', Time.zone.today]).each do |coupon|
      I18n.locale = :zh
      print_property = CouponPrintProperty.find_by_coupon_id(coupon.id)
      properties = Yajl::Parser.parse(print_property.properties)
      errors = {}
      properties.each do |k, v|
        if v.to_s.blank?
          errors[k] = "信息缺失!"
        end
      end

      # 对日期进行校验
      end_date_str = properties["activity_end_at"]
      unless end_date_str.to_s.blank?
        end_date_str = end_date_str.gsub(/[年|月|日]/, '-').chomp("-")
        end_date = end_date_str.to_date
        if end_date < Time.zone.today
          if errors.has_key? "activity_end_at"
            errors[activity_end_at] = errors[activity_end_at] + " :#{end_date_str} 已失效!"
          else
            errors[activity_end_at] = ":#{end_date_str} 已失效!"
          end
        end
      end

      if errors.size > 0
        puts "#" * 20
        puts "#= 抵用券-编号: #{coupon.id} 提示:"
        errors.each do |k, v|
          #{Coupon.human_attribute_name(k)} : #{v}"
          puts "##{' ' * 5}#{Coupon.human_attribute_name(k)}: #{v}"
        end
        puts "#" * 20
        puts ""
      #else
      #  puts "数据正常"
      end

    end
  end

end