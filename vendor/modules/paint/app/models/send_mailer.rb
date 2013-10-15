#require 'abstract_unit'
class SendMailer < ActionMailer::Base
  
  def paint_workers(recipient,title)
      recipients      recipient
      subject         title
      from            "cs@51hejia.com"
      sent_on         Time.now
  end
  
  def paiqian(recipient,title)
      recipients      recipient
      subject         title
      from            "cs@51hejia.com"
      sent_on         Time.now
  end
  
   def training(recipient,title)
      recipients      recipient
      subject         title
      from            "cs@51hejia.com"
      sent_on         Time.now
  end
  
  def audit_paint_cases_mail(recipient,title)
    recipients      recipient
    subject         title
    from            "cs@51hejia.com"
    sent_on         Time.now
  end
  
  def edm_for_month_in_9_10_11(recipient,title)
    recipients      recipient
    subject         title
    from            "cs@51hejia.com"
    sent_on         Time.now
  end
  
  def yougong_zhuce_tongji(recipient,title,content)
    recipients recipient
    subject title
    from 'cs@51hejia.com'
    sent_on Time.now
    body content
  end
  
end
