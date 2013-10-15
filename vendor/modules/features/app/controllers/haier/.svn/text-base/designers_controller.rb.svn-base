class Haier::DesignersController < Haier::ApplicationController

  skip_filter :auto_expire, :only => [:jzsjs, :jdsjs]
  
  def show1
    @cases_array = HejiaCase.find(:all, :conditions => "ID in (536900,536904,536902,536903)")
    @case = HejiaCase.find(params[:id])
    case_other_info(@case)
  end

  def show2
    @cases_array = HejiaCase.find(:all, :conditions => "ID in (536990,536993,536999,536997)")
    @case = HejiaCase.find(params[:id])
    case_other_info(@case)
  end

  def jzsjs
    @questions = AskZhidaoTopic.user_answer(7372749)
    @questions_jd = AskZhidaoTopic.user_answer(7356049)
  end

  def jdsjs
    @questions = AskZhidaoTopic.user_answer(7356049)
    @questions_jz = AskZhidaoTopic.user_answer(7372749)
  end

  def case_other_info(cases)
    $redis.set "case/show/#{cases.ID}/caseup", cases.CASEUP if $redis.get("case/show/#{cases.ID}/caseup").nil?
    $redis.set "case/show/#{cases.ID}/casedown", cases.CASEDOWN if $redis.get("case/show/#{cases.ID}/casedown").nil?
  end

end