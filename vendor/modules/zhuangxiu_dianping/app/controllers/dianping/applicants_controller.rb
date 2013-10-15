class Dianping::ApplicantsController < Dianping::ApplicationController
  
  def new
    @applicant = Applicant.new
    @firm = DecoFirm.find(params[:deco_firm_id])
    @appointment_type = params[:type] || 0 
    @city_name = CITIES[@user_city_code.to_i]
    
    
    render :layout => false
  end
  
  def create
    @applicant = Applicant.new(params[:applicant])
    if @applicant.save
      #后台商家有保存手机号的再预约成功后发送短信通知
      msg_phone = @applicant.deco_firm.msg_phone
      if msg_phone && !msg_phone.blank?
        msg_text = '尊敬的商家您好，您有新的业主预约量房参观工地，业主联系方式请登录和家网商家后台查看，或与编辑联系！'
        Hejia::SMS.send_text_message(msg_text,msg_phone)
      end
      render :text => [1,@applicant.deco_firm.name_abbr]
    else
      render :text => [0,@applicant.deco_firm.name_abbr]
    end
  end
  
end
