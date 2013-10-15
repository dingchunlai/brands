namespace :insert_htmlmetadata_to_database do
  desc '添加新城市点评的标题关键字'
  task :htmlmetadata_to_database =>:environment do
    city = ENV["CITY"]
    abort 'city is missing' unless city
    city = City.find_by_pinyin(city)
    abort 'city not found' unless city
    city = city.name
    sql = "INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:优惠券列表页', '装修优惠,装修公司优惠活动-#{city}和家网装修点评', '装修优惠,装修公司优惠活动', '和家网专业提供最新装修优惠和家装优惠活动信息,提供#{city}全部装修公司的优惠活动和装修优惠信息,让你装修更优惠,装潢更省力!', '#{city}:装修点评:优惠券列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:优惠券终端页', '优惠信息-%{firm_name}装修公司', '', '', '#{city}:装修点评:优惠券终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页', '装修装饰公司,装修公司排名,装修设计公司排名-#{city}和家网装修点评', '装修公司,装饰公司,装修公司排名', '囊括#{city}所有装修装饰公司,罗列全部装修公司排名,点评#{city}知名装修设计公司,为大家展示各种装修设计公司的风格和案例,真实反应各家装修公司和装潢公司的综合水平.', '#{city}:装修点评:公司列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-三房', '三房装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-三房');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-两房', '两房装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-两房');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-中式风格', '中式风格装修,中式别墅装修设计-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-中式风格');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-价位', '%{price}-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-价位');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-全包', '全包,装修全包价格-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-全包');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-别墅', '别墅装修,别墅装潢设计-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-别墅');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-半包', '半包,装修半包价格-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-半包');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-四房装修', '四房装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-四房装修');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-地中海', '地中海风格,地中海装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-地中海');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-地区', '%{district}-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-地区');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-复式', '复式装修,小复式装修,复式房|楼装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-复式');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-小户型', '小户型装修,小户型复式装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-小户型');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-欧美式', '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-欧美式');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-混搭', '#{city}:混搭风格,混搭装修方式-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-混搭');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-清包', '清包,清包装修,装修方式价格-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-清包');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-现代简约', '现代简约风格,现代简约装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-现代简约');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-田园风格', '田园风格,田园风格装修-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-田园风格');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司列表页-设计工作室', '设计工作室-装修公司列表-#{city}和家网装修点评', '', '', '#{city}:装修点评:公司列表页-设计工作室');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司在建工地列表页', '在建工地-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司在建工地列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司施工图片列表页', '施工图片,装修故事,装潢故事-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司施工图片列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司日记列表页', '装修日记,装潢日记,点评日记-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司日记列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司案例列表页', '案例图片,装修图片,装潢图片-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司案例列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司终端页', '%{firm_name}装修公司-#{city}和家网装修公司', '', '', '#{city}:装修点评:公司终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司设计师列表页', '设计师-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司设计师列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:公司设计理念列表页', '设计理念-%{firm_name}装修公司', '', '', '#{city}:装修点评:公司设计理念列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:排行榜', '装修公司排名,家装公司排名-#{city}和家网装修点评', '装修公司排名', '和家网装修点评频道提供#{city}装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!', '#{city}:装修点评:排行榜');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:施工图片列表页', '室内设计,家装设计,施工图片大全-#{city}和家网装修点评', '室内设计,施工图', '我们提供装修过程中的各种施工图,其中不乏室内设计大师的经典作品,符合您的各种家装设计要求的施工图片大全,可以根据这些施工图来选择合适的室内设计和家装设计.', '#{city}:装修点评:施工图片列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:日记列表页', '装修日记,装饰日记,装潢日记-#{city}和家网装修点评', '装修日记', '和家网汇集#{city}网友亲身装修经历,记录最真实最完整的装修日记,装饰日记和装潢日志,包含小户型,两房,三房,复式,别墅等多种房型的装修过程,配套装修案例图片和装修施工图,让您不在现场也身临其境,学到更多装修知识.', '#{city}:装修点评:日记列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:日记终端页', '%{decoration_diary_name}-装修日记-#{city}和家网装修点评', '%{decoration_diary_name}', '', '#{city}:装修点评:日记终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页', '装修图片,装修效果图,装饰装潢效果图大全-#{city}和家网装修点评', '装修图片,装修效果图', '和家网汇集#{city}装修公司装修图片,室内各种装修效果图,包含不同风格的厨房,卧室,客厅等装修装潢效果图大全,做为业主选择装修设计公司的参考.各种装修装饰图片以装修风格|装修户型|装修价格和装修用途分类,尽可能帖近生活.', '#{city}:装修点评:案例图片列表页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-中式风格', '中式风格案例图片,中式风格装修图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-中式风格');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-别墅', '别墅案例图片,别墅装修图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-别墅');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-地中海', '地中海案例图片,地中海装修案例图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-地中海');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-复式', '复式案例图片,复式装修案例图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-复式');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-小户型', '小户型案例图片,小户型装修案例图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-小户型');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-欧美式', '欧美式案例图片,欧美式装修图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-欧美式');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-混搭', '混搭案例图片,混搭装修图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-混搭');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-现代简约', '现代简约案例图片,现代简约装修图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-现代简约');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-田园风格', '田园风格案例图片,田园风格装修案例图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-田园风格');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片列表页-通用', '%{condition}案例图片,%{condition}装修案例图片-#{city}和家网装修点评', '', '', '#{city}:装修点评:案例图片列表页-通用');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:案例图片终端页', '%{case_name}-装修图片-#{city}和家网装修点评', '%{case_name}', '', '#{city}:装修点评:案例图片终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:设计师终端页', '%{designer_name}-家装设计师-#{city}和家网装修点评', '%{designer_name}', '', '#{city}:装修点评:设计师终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:设计理念终端页', '%{idea_name}-设计理念-#{city}和家网', '%{idea_name}', '', '#{city}:装修点评:设计理念终端页');
INSERT INTO `html_metadata` (`url`, `title`, `keywords`, `description`, `page_id`) VALUES ('z.51hejia.com/#{city}:装修点评:首页', '#{city}装修装潢,#{city}装饰公司,家居装修网-#{city}和家网装修点评', '#{city}装修,#{city}装潢,装修网,家居装修', '看和家装修网,看装修日记,看网友点评#{city}装修,看#{city}装潢公司排名,选知名#{city}装修公司!另有真实装修案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新#{city}装修装潢促销活动信息,让您选择装修时也可以顺时而动.', '#{city}:装修点评:首页');"

    #File.open('/tmp/wuhan.sql').each_line do |s|
    #  puts "正在执行 >>>> #{s}"
    #  HtmlMetadata.connection.execute s
    #end
    #puts sql.split("\n").size
    sql.split("\n").each do |s|
      puts "正在执行 >>>> #{s}"
      HtmlMetadata.connection.execute s
    end
  end
end
