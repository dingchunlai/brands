class Notifier < ActionMailer::Base
  #config.action_mailer.default_url_options = {:host => "51hejia.com"}

  def welcome(user)
    subject "欢迎"
    from "noreply@51hejia.com"
    recipients user.USERBBSEMAIL
    sent_on Time.now
    body :user => user
  end

  def notice_remain_issue(remind_mail, coupons)
    content_type "text/html"
    charset "utf-8"
    subject "提醒：#{Coupon::CITIES[remind_mail.city_id]}——现金券可用下载量不足"
    from "cs@51hejia.com"
    recipients remind_mail.recipient.to_s.strip.split("\n").join(",")
    cc remind_mail.cc.to_s.strip.split("\n").join(",")
    sent_on Time.now
    body :coupons => coupons
  end

end