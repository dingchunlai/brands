class Dianping::DecoRegistersController < Dianping::ApplicationController
  
  def new
    @firm = CaseFactoryCompany.find(params[:event_id]).deco_firm unless params[:event_id].blank?
    @city_name = CITIES[@user_city_code.to_i]
    @deco_register = DecoRegister.new
    render :layout => false
  end
  
  def new_iframe
    @firm = CaseFactoryCompany.find(params[:event_id]).deco_firm unless params[:event_id].blank?
      @city_name = CITIES[@user_city_code.to_i]
      @deco_register = DecoRegister.new
      render :layout => false
  end
  
  def create
    firmname = params[:deco_register][:firmname]
    params[:deco_register].delete :deco_register
    new_register = DecoRegister.new(params[:deco_register])
    if new_register.save
      #后台商家有保存手机号的再预约成功后发送短信通知
      msg_phone = CaseFactoryCompany.find(new_register.event_id).deco_firm.msg_phone
      if msg_phone && !msg_phone.blank?
        msg_text = '尊敬的商家您好，您有新的业主预约量房参观工地，业主联系方式请登录和家网商家后台查看，或与编辑联系！'
        Hejia::SMS.send_text_message(msg_text,msg_phone)
      end
      if params[:back_url].nil?
        render :text => [1,firmname]
      else
        redirect_to params[:back_url]
      end
    else
      render :text => 0
    end
  end
  
end
