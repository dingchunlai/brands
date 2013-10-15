# 抵用券每日任务
namespace :coupon do
  desc "Coupon daily jobs"
  task :daily_jobs => :environment do
    # 更新抵用券状态
    Rake::Task["coupon:update_coupon_status"].invoke
    # 更新抵用券佣金
    Rake::Task["coupon:update_commission"].invoke
    # 抵用券可下载数不足 邮件提醒
    Rake::Task["coupon:remind_mail"].invoke
  end
end
