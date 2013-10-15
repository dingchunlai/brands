class Dianping::FactoriesController < Dianping::ApplicationController
  helper :all
  caches_action :index, :expires_in => 5.minutes

  def index
    #按条件分类 公司top 10
    @assort_firms = []
    @assort_firms = DecoFirm.firms_by_assort_for(nil,nil,nil).by_city(@user_city_code).firms_by_cooperation_praise_for([],10)
    if @assort_firms.size < 10
      @assort_firms = @assort_firms + DecoFirm.by_city(@user_city_code).firms_by_cooperation_praise_for(@assort_firms.map{|firm| firm.id},10 - @assort_firms.size ).find(:all , :select => "id,name_abbr, praise")
    end  
    @factories = CaseFactoryCompany.with_city(@user_city_code).paginate :page => params[:page], :per_page => 20
  end

end
