desc '添加点评页面的TITLE等 ..'
task :seo_for_dianping =>:environment  do
  html_metadata =  [
    {
      :page_id => '上海:装修点评:首页',
      :title =>  '上海装修装潢,上海装饰公司,家居装修网-上海和家网装修点评',
      :keywords => '上海装修,上海装潢,装修网,家居装修',
      :description => '看和家装修网,看装修日记,看网友点评上海装修,看上海装潢公司排名,选知名上海装修公司!另有真实装修案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新上海装修装潢促销活动信息,让您选择装修时也可以顺时而动.'
    },
    {
      :page_id => '上海:装修点评:公司列表页',
      :title =>  '装修装饰公司,装修公司排名,装修设计公司排名-上海和家网装修点评',
      :keywords => '装修公司,装饰公司,装修公司排名',
      :description => '囊括上海所有装修装饰公司,罗列全部装修公司排名,点评上海知名装修设计公司,为大家展示各种装修设计公司的风格和案例,真实反应各家装修公司和装潢公司的综合水平.'
    },
    {
      :page_id => '上海:装修点评:公司终端页',
      :title =>  '%{firm_name}装修公司-上海和家网装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司日记列表页',
      :title =>  '装修日记,装潢日记,点评日记-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司案例列表页',
      :title =>  '案例图片,装修图片,装潢图片-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司施工图片列表页',
      :title =>  '施工图片,装修故事,装潢故事-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司在建工地列表页',
      :title =>  '在建工地-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司设计师列表页',
      :title =>  '设计师-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司设计理念列表页',
      :title =>  '设计理念-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-价位',
      :title =>  '%{price}-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-现代简约',
      :title =>  '现代简约风格,现代简约装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-欧美式',
      :title =>  '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-中式风格',
      :title =>  '中式风格装修,中式别墅装修设计-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-地中海',
      :title =>  '地中海风格,地中海装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-混搭',
      :title =>  '上海:混搭风格,混搭装修方式-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-清包',
      :title =>  '清包,清包装修,装修方式价格-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-半包',
      :title =>  '半包,装修半包价格-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-全包',
      :title =>  '全包,装修全包价格-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-设计工作室',
      :title =>  '设计工作室-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-小户型',
      :title =>  '小户型装修,小户型复式装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-两房',
      :title =>  '两房装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-三房',
      :title =>  '三房装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-四房装修',
      :title =>  '四房装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-复式',
      :title =>  '复式装修,小复式装修,复式房|楼装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-别墅',
      :title =>  '别墅装修,别墅装潢设计-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:日记列表页',
      :title =>  '装修日记,装饰日记,装潢日记-上海和家网装修点评',
      :keywords => '装修日记',
      :description => '和家网汇集上海网友亲身装修经历,记录最真实最完整的装修日记,装饰日记和装潢日志,包含小户型,两房,三房,复式,别墅等多种房型的装修过程,配套装修案例图片和装修施工图,让您不在现场也身临其境,学到更多装修知识.'
    },
     {
        :page_id => '上海:装修点评:日记终端页',
        :title =>  '%{decoration_diary_name}-装修日记-上海和家网装修点评',
        :keywords => '%{decoration_diary_name}',
        :description => ''
      },
    {
      :page_id => '上海:装修点评:案例图片列表页',
      :title =>  '装修图片,装修效果图,装饰装潢效果图大全-上海和家网装修点评',
      :keywords => '装修图片,装修效果图',
      :description => '和家网汇集上海装修公司装修图片,室内各种装修效果图,包含不同风格的厨房,卧室,客厅等装修装潢效果图大全,做为业主选择装修设计公司的参考.各种装修装饰图片以装修风格|装修户型|装修价格和装修用途分类,尽可能帖近生活.'
    },
    {
      :page_id => '上海:装修点评:案例图片终端页',
      :title =>  '%{case_name}-装修图片-上海和家网装修点评',
      :keywords => '%{case_name}',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-现代简约',
      :title =>  '现代简约案例图片,现代简约装修图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-田园风格',
      :title =>  '田园风格案例图片,田园风格装修案例图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-欧美式',
      :title =>  '欧美式案例图片,欧美式装修图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-中式风格',
      :title =>  '中式风格案例图片,中式风格装修图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-地中海',
      :title =>  '地中海案例图片,地中海装修案例图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-混搭',
      :title =>  '混搭案例图片,混搭装修图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-小户型',
      :title =>  '小户型案例图片,小户型装修案例图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-别墅',
      :title =>  '别墅案例图片,别墅装修图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-复式',
      :title =>  '复式案例图片,复式装修案例图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:案例图片列表页-通用',
      :title =>  '%{condition}案例图片,%{condition}装修案例图片-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:施工图片列表页',
      :title =>  '室内设计,家装设计,施工图片大全-上海和家网装修点评',
      :keywords => '室内设计,施工图',
      :description => '我们提供装修过程中的各种施工图,其中不乏室内设计大师的经典作品,符合您的各种家装设计要求的施工图片大全,可以根据这些施工图来选择合适的室内设计和家装设计.'
    },
    {
      :page_id => '上海:装修点评:排行榜',
      :title =>  '装修公司排名,家装公司排名-上海和家网装修点评',
      :keywords => '装修公司排名',
      :description => '和家网装修点评频道提供上海装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!'
    },
    {
      :page_id => '上海:装修点评:优惠券列表页',
      :title =>  '装修优惠,装修公司优惠活动-上海和家网装修点评',
      :keywords => '装修优惠,装修公司优惠活动',
      :description => '和家网专业提供最新装修优惠和家装优惠活动信息,提供上海全部装修公司的优惠活动和装修优惠信息,让你装修更优惠,装潢更省力!'
    },
    {
      :page_id => '上海:装修点评:优惠券终端页',
      :title =>  '优惠信息-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:设计师终端页',
      :title =>  '%{designer_name}-家装设计师-上海和家网装修点评',
      :keywords => '%{designer_name}',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:设计理念终端页',
      :title =>  '%{idea_name}-设计理念-上海和家网',
      :keywords => '%{idea_name}',
      :description => ''
    },
    # 宁波>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1>>>>>>>>>>>>>>>>>>>>>>> >>>>> >>>>>>>>>>>>>>>>>>>>>>>>
    {
      :page_id => '宁波:装修点评:首页',
      :title =>  '宁波装饰装修,宁波装修公司网-宁波和家网装修点评',
      :keywords => '宁波装饰,宁波装修,宁波装修公司',
      :description => '和家装修网宁波站,提供宁波装饰公司,宁波装修公司排名,看网友点评各家宁波装修公司,看宁波装饰公司排名,选知名宁波装修公司!另有真实装修装潢设计案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新宁波装修装潢团购促销活动信息,让您选择装修时也可以顺时而动.'
    },
    {
      :page_id => '宁波:装修点评:公司列表页',
      :title =>  '装修设计公司,装饰设计公司排名-宁波和家网装修点评',
      :keywords => '装修设计公司,装饰设计公司',
      :description => '囊括宁波所有装修设计公司,罗列全部装饰设计公司排名,点评宁波知名装修设计公司,为大家展示各种装修设计公司的风格和案例,真实反应各家装修设计公司和装饰设计公司的综合水平.'
    },
    {
      :page_id => '宁波:装修点评:公司终端页',
      :title =>  '%{firm_name}装修公司-宁波和家网装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司日记列表页',
      :title =>  '装修日记,装潢日记,点评日记-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司案例列表页',
      :title =>  '案例图片,装修图片,装潢图片-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司施工图片列表页',
      :title =>  '施工图片,装修故事,装潢故事-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司在建工地列表页',
      :title =>  '在建工地-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司设计师列表页',
      :title =>  '设计师-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司设计理念列表页',
      :title =>  '设计理念-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-价位',
      :title =>  '%{price}-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-现代简约',
      :title =>  '现代简约风格,现代简约装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-欧美式',
      :title =>  '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-中式风格',
      :title =>  '中式风格装修,中式别墅装修设计-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-地中海',
      :title =>  '地中海风格,地中海装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-混搭',
      :title =>  '混搭风格,混搭装修方式-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-清包',
      :title =>  '清包,清包装修,装修方式价格-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-半包',
      :title =>  '半包,装修半包价格-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-全包',
      :title =>  '全包,装修全包价格-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-设计工作室',
      :title =>  '设计工作室-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-小户型',
      :title =>  '小户型装修,小户型复式装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-两房',
      :title =>  '两房装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-三房',
      :title =>  '三房装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-四房装修',
      :title =>  '四房装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-复式',
      :title =>  '复式装修,小复式装修,复式房|楼装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-别墅',
      :title =>  '别墅装修,别墅装潢设计-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:日记列表页',
      :title =>  '清包装潢日记,二手房装修日记,小户型装修日记-宁波和家网装修点评',
      :keywords => '清包装潢日记,二手房装修日记',
      :description => '和家网汇集宁波网友亲身装潢经历,记录最真实最完整的清包装潢日记,二手房装修日记,小户型装修日记等,包含小户型,两房,三房,复式,别墅等多种房型,包含清包,半包,全包的装修过程,让您不在现场也身临其境,学到更多装修知识.'
    },
     {
        :page_id => '宁波:装修点评:日记终端页',
        :title =>  '%{decoration_diary_name}-装修日记-宁波和家网装修点评',
        :keywords => '%{decoration_diary_name}',
        :description => ''
      },
    {
      :page_id => '宁波:装修点评:案例图片列表页',
      :title =>  '装修装潢图片网,装潢图库-宁波和家网装修点评',
      :keywords => '装修图片网,装潢图片网,装潢图库',
      :description => '和家网汇集宁波装修公司的各种装修图片和装潢图片,室内各种装潢图库,包含不同风格的厨房,卧室,客厅等装潢装饰效果图大全,做为业主选择装潢公司的参考.各种装潢图片以装潢风格|装潢户型|装潢价格和装潢用途分类,尽可能帖近生活.'
    },
    {
      :page_id => '宁波:装修点评:案例图片终端页',
      :title =>  '%{case_name}-装修图片-宁波和家网装修点评',
      :keywords => '%{case_name}',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-现代简约',
      :title =>  '现代简约案例图片,现代简约装修图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-田园风格',
      :title =>  '田园风格案例图片,田园风格装修案例图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-欧美式',
      :title =>  '欧美式案例图片,欧美式装修图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-中式风格',
      :title =>  '中式风格案例图片,中式风格装修图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-地中海',
      :title =>  '地中海案例图片,地中海装修案例图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-混搭',
      :title =>  '混搭案例图片,混搭装修图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-小户型',
      :title =>  '小户型案例图片,小户型装修案例图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-别墅',
      :title =>  '别墅案例图片,别墅装修图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-复式',
      :title =>  '复式案例图片,复式装修案例图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:案例图片列表页-通用',
      :title =>  '%{condition}案例图片,%{condition}装修案例图片-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:施工图片列表页',
      :title =>  '家居施工,整体家居施工图,智能家居施工图-宁波和家网装修点评',
      :keywords => '家居施工,整体家居施工',
      :description => '我们提供装修过程中的各种家居施工图,其中不乏整体家居施工图,智能家居施工图片,符合您的各种装潢装修施工要求的家居施工图片大全,可以根据这些施工图来选择合适的装修施工团队.'
    },
    {
      :page_id => '宁波:装修点评:排行榜',
      :title =>  '装修公司排名,家装公司排名-宁波和家网装修点评',
      :keywords => '装修公司排名',
      :description => '和家网装修点评频道提供宁波装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!'
    },
    {
      :page_id => '宁波:装修点评:优惠券列表页',
      :title =>  '家装优惠,家装优惠活动-宁波和家网装修点评',
      :keywords => '家装优惠,家装优惠活动',
      :description => '和家网宁波站专业提供最新装修优惠信息和家装优惠活动信息,提供宁波全部装潢装修公司的优惠活动和优惠信息,让你装修装潢更优惠更省力!'
    },
    {
      :page_id => '宁波:装修点评:优惠券终端页',
      :title =>  '优惠信息-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:设计师终端页',
      :title =>  '%{designer_name}-家装设计师-宁波和家网装修点评',
      :keywords => '%{designer_name}',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:设计理念终端页',
      :title =>  '%{idea_name}-设计理念-宁波和家网',
      :keywords => '%{idea_name}',
      :description => ''
    },
    # 苏州>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2>>>>>>>>>>>> >>>>> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    {
      :page_id => '苏州:装修点评:首页',
      :title =>  '苏州装饰装修,苏州装潢公司,家居装修网-苏州和家网装修点评',
      :keywords => '苏州装饰,苏州装修,苏州装潢,装潢公司',
      :description => '和家装修网苏州站,提供苏州装饰公司,苏州装修装潢公司排名,看网友点评苏州装修,看苏州装潢公司排名,选知名苏州装修公司!另有真实装修案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新苏州装修装潢促销活动信息,让您选择装修时也可以顺时而动.'
    },
    {
      :page_id => '苏州:装修点评:公司列表页',
      :title =>  '装饰公司,装饰公司排名,装饰设计公司排名-苏州和家网装修点评',
      :keywords => '装饰公司,装饰公司排名',
      :description => '囊括苏州所有装修装饰公司,罗列全部装饰公司排名,点评苏州知名装饰设计公司,为大家展示各种装饰设计公司的风格和案例,真实反应各家装修公司和装潢公司的综合水平.'
    },
    {
      :page_id => '苏州:装修点评:公司终端页',
      :title =>  '%{firm_name}装修公司-苏州和家网装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司日记列表页',
      :title =>  '装修日记,装潢日记,点评日记-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司案例列表页',
      :title =>  '案例图片,装修图片,装潢图片-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司施工图片列表页',
      :title =>  '施工图片,装修故事,装潢故事-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司在建工地列表页',
      :title =>  '在建工地-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司设计师列表页',
      :title =>  '设计师-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司设计理念列表页',
      :title =>  '设计理念-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-价位',
      :title =>  '%{price}-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-现代简约',
      :title =>  '现代简约风格,现代简约装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-欧美式',
      :title =>  '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-中式风格',
      :title =>  '中式风格装修,中式别墅装修设计-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-地中海',
      :title =>  '地中海风格,地中海装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-混搭',
      :title =>  '混搭风格,混搭装修方式-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-清包',
      :title =>  '清包,清包装修,装修方式价格-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-半包',
      :title =>  '半包,装修半包价格-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-全包',
      :title =>  '全包,装修全包价格-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-设计工作室',
      :title =>  '设计工作室-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-小户型',
      :title =>  '小户型装修,小户型复式装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-两房',
      :title =>  '两房装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-三房',
      :title =>  '三房装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-四房装修',
      :title =>  '四房装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-复式',
      :title =>  '复式装修,小复式装修,复式房|楼装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-别墅',
      :title =>  '别墅装修,别墅装潢设计-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:日记列表页',
      :title =>  '装饰日记,装饰公司日记-苏州和家网装修点评',
      :keywords => '装饰日记',
      :description => '和家网汇集苏州网友亲身装饰经历,记录最真实最完整的装饰日记和装潢日志,包含小户型,两房,三房,复式,别墅等多种房型的装饰装修过程,配套装饰案例图片和装饰施工图,让您不在现场也身临其境,学到更多装修知识.'
    },
     {
        :page_id => '苏州:装修点评:日记终端页',
        :title =>  '%{decoration_diary_name}-装修日记-苏州和家网装修点评',
        :keywords => '%{decoration_diary_name}',
        :description => ''
      },
    {
      :page_id => '苏州:装修点评:案例图片列表页',
      :title =>  '装饰图片,装饰效果图,装饰风格效果图大全-苏州和家网装修点评',
      :keywords => '装饰图片,装饰效果图',
      :description => '和家网汇集苏州装饰公司装饰图片,室内各种装饰效果图,包含不同风格的厨房,卧室,客厅等装修装饰效果图大全,做为业主选择装饰设计公司的参考.各种装饰图片以装饰风格|装饰户型|装饰价格和装饰用途分类,尽可能帖近生活.'
    },
    {
      :page_id => '苏州:装修点评:案例图片终端页',
      :title =>  '%{case_name}-装修图片-苏州和家网装修点评',
      :keywords => '%{case_name}',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-现代简约',
      :title =>  '现代简约案例图片,现代简约装修图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-田园风格',
      :title =>  '田园风格案例图片,田园风格装修案例图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-欧美式',
      :title =>  '欧美式案例图片,欧美式装修图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-中式风格',
      :title =>  '中式风格案例图片,中式风格装修图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-地中海',
      :title =>  '地中海案例图片,地中海装修案例图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-混搭',
      :title =>  '混搭案例图片,混搭装修图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-小户型',
      :title =>  '小户型案例图片,小户型装修案例图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-别墅',
      :title =>  '别墅案例图片,别墅装修图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-复式',
      :title =>  '复式案例图片,复式装修案例图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:案例图片列表页-通用',
      :title =>  '%{condition}案例图片,%{condition}装修案例图片-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:施工图片列表页',
      :title =>  '装修施工,家装施工图片大全-苏州和家网装修点评',
      :keywords => '装修施工,家装施工',
      :description => '我们提供装修过程中的各种装修施工图和家装施工图片,其中不乏家装施工大师的经典作品,符合您的各种装修施工要求的家装施工图片大全,可以根据这些施工图来选择合适的装修施工团队.'
    },
    {
      :page_id => '苏州:装修点评:排行榜',
      :title =>  '装修公司排名,家装公司排名-苏州和家网装修点评',
      :keywords => '装修公司排名',
      :description => '和家网装修点评频道提供苏州装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!'
    },
    {
      :page_id => '苏州:装修点评:优惠券列表页',
      :title =>  '装饰优惠活动,装饰公司优惠活动-苏州和家网装修点评',
      :keywords => '装饰优惠,装饰公司优惠活动',
      :description => '和家网苏州站专业提供最新装饰优惠和装饰公司活动信息,提供苏州全部装饰装修公司的优惠活动和优惠信息,让你装修装饰更优惠更省力!'
    },
    {
      :page_id => '苏州:装修点评:优惠券终端页',
      :title =>  '优惠信息-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:设计师终端页',
      :title =>  '%{designer_name}-家装设计师-苏州和家网装修点评',
      :keywords => '%{designer_name}',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:设计理念终端页',
      :title =>  '%{idea_name}-设计理念-苏州和家网',
      :keywords => '%{idea_name}',
      :description => ''
    },
# 无锡>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >>>>> >>>>>>>>>>3>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    {
      :page_id => '无锡:装修点评:首页',
      :title =>  '无锡装饰装修,无锡装潢公司-无锡和家网装修点评',
      :keywords => '无锡装饰,无锡装修,无锡装潢',
      :description => '和家装修网无锡站,提供无锡装饰公司,无锡装修装潢公司排名,看网友点评无锡装修,看无锡装潢公司排名,选知名无锡装修公司!另有真实装修案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新无锡装修装潢促销活动信息,让您选择装修时也可以顺时而动.'
    },
    {
      :page_id => '无锡:装修点评:公司列表页',
      :title =>  '无锡装饰公司,装修公司排名,装饰设计公司排名-无锡和家网装修点评',
      :keywords => '无锡装饰公司,装修公司排名',
      :description => '囊括无锡所有装修装饰公司,罗列全部装饰公司排名,点评无锡知名装饰设计公司,为大家展示各种装饰设计公司的风格和案例,真实反应各家装修公司和装潢公司的综合水平.'
    },
    {
      :page_id => '无锡:装修点评:公司终端页',
      :title =>  '%{firm_name}装修公司-无锡和家网装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司日记列表页',
      :title =>  '装修日记,装潢日记,点评日记-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司案例列表页',
      :title =>  '案例图片,装修图片,装潢图片-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司施工图片列表页',
      :title =>  '施工图片,装修故事,装潢故事-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司在建工地列表页',
      :title =>  '在建工地-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司设计师列表页',
      :title =>  '设计师-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司设计理念列表页',
      :title =>  '设计理念-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-价位',
      :title =>  '%{price}-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-现代简约',
      :title =>  '现代简约风格,现代简约装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-欧美式',
      :title =>  '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-中式风格',
      :title =>  '中式风格装修,中式别墅装修设计-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-地中海',
      :title =>  '地中海风格,地中海装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-混搭',
      :title =>  '混搭风格,混搭装修方式-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-清包',
      :title =>  '清包,清包装修,装修方式价格-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-半包',
      :title =>  '半包,装修半包价格-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-全包',
      :title =>  '全包,装修全包价格-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-设计工作室',
      :title =>  '设计工作室-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-小户型',
      :title =>  '小户型装修,小户型复式装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-两房',
      :title =>  '两房装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-三房',
      :title =>  '三房装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-四房装修',
      :title =>  '四房装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-复式',
      :title =>  '复式装修,小复式装修,复式房|楼装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-别墅',
      :title =>  '别墅装修,别墅装潢设计-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:日记列表页',
      :title =>  '装饰日记,装饰综合日记-无锡和家网装修点评',
      :keywords => '装饰日记,装饰综合日记',
      :description => '和家网汇集无锡网友亲身装饰经历,记录最真实最完整的装饰综合日记日记和装潢综合日志,包含小户型,两房,三房,复式,别墅等多种房型的装饰装修过程,配套装饰案例图片和装饰施工图,让您不在现场也身临其境,学到更多装饰知识.'
    },
     {
        :page_id => '无锡:装修点评:日记终端页',
        :title =>  '%{decoration_diary_name}-装修日记-无锡和家网装修点评',
        :keywords => '%{decoration_diary_name}',
        :description => ''
      },
    {
      :page_id => '无锡:装修点评:案例图片列表页',
      :title =>  '客厅装修图片,小户型装修图片,室内装修效果图-无锡和家网装修点评',
      :keywords => '客厅装修图片,小户型装修图片',
      :description => '和家网汇集无锡客厅装修图片,小户型装修图片,室内各种装修效果图,包含不同风格的厨房,卧室,客厅等装修效果图大全,做为业主选择装饰设计公司的参考.各种装修图片以装修风格|装修户型|装修价格和装修用途分类,尽可能帖近生活.'
    },
    {
      :page_id => '无锡:装修点评:案例图片终端页',
      :title =>  '%{case_name}-装修图片-无锡和家网装修点评',
      :keywords => '%{case_name}',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-现代简约',
      :title =>  '现代简约案例图片,现代简约装修图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-田园风格',
      :title =>  '田园风格案例图片,田园风格装修案例图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-欧美式',
      :title =>  '欧美式案例图片,欧美式装修图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-中式风格',
      :title =>  '中式风格案例图片,中式风格装修图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-地中海',
      :title =>  '地中海案例图片,地中海装修案例图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-混搭',
      :title =>  '混搭案例图片,混搭装修图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-小户型',
      :title =>  '小户型案例图片,小户型装修案例图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-别墅',
      :title =>  '别墅案例图片,别墅装修图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-复式',
      :title =>  '复式案例图片,复式装修案例图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:案例图片列表页-通用',
      :title =>  '%{condition}案例图片,%{condition}装修案例图片-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:施工图片列表页',
      :title =>  '装饰工程施工,家装施工流程-无锡和家网装修点评',
      :keywords => '装饰工程施工,家装施工流程',
      :description => '我们提供装饰过程中的各种装饰工程施工图和家装施工流程图片,其中不乏家装施工大师的经典作品,符合您的各种装饰施工要求的家装施工图片大全,可以根据这些施工图来选择合适的装修施工团队.'
    },
    {
      :page_id => '无锡:装修点评:排行榜',
      :title =>  '装修公司排名,家装公司排名-无锡和家网装修点评',
      :keywords => '装修公司排名',
      :description => '和家网装修点评频道提供无锡装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!'
    },
    {
      :page_id => '无锡:装修点评:优惠券列表页',
      :title =>  '家装优惠,家装公司优惠活动-无锡和家网装修点评',
      :keywords => '家装优惠,家装公司优惠活动',
      :description => '和家网无锡站专业提供最新家装优惠和家装公司活动信息,提供无锡全部家装公司的优惠活动和优惠信息,让你装修家装更优惠更省力!'
    },
    {
      :page_id => '无锡:装修点评:优惠券终端页',
      :title =>  '优惠信息-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:设计师终端页',
      :title =>  '%{designer_name}-家装设计师-无锡和家网装修点评',
      :keywords => '%{designer_name}',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:设计理念终端页',
      :title =>  '%{idea_name}-设计理念-无锡和家网',
      :keywords => '%{idea_name}',
      :description => ''
    },  
    # 杭州>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >>>>> >>>>>>>>>>4>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
   {
    :page_id => '杭州:装修点评:首页',
    :title =>  '杭州装修公司,杭州室内装修设计公司-杭州和家网装修点评',
    :keywords => '杭州装修公司,杭州室内装修公司',
    :description => '和家装修网杭州站,提供杭州装修公司,杭州室内装修公司排名,看网友点评杭州装修,看杭州装修公司排名,选知名杭州装修公司!另有真实装修设计案例点评,鲜活装修日记,装饰日记等,反映装修现状,同时各种装潢风格装修效果图,为您装修装潢做借鉴.提供最新杭州装修团购促销活动信息,让您选择装修时也可以顺时而动.'
    },
  {
      :page_id => '杭州:装修点评:公司列表页',
      :title =>  '装潢公司,装潢公司排名,装潢设计公司排名-杭州和家网装修点评',
      :keywords => '装潢公司,装潢公司排名',
      :description => '囊括杭州所有装修装潢公司,罗列全部装潢公司排名,点评杭州知名装潢设计公司,为大家展示各种装潢设计公司的风格和案例,真实反应各家装潢公司和装饰公司的综合水平.'
    },
    {
      :page_id => '杭州:装修点评:公司终端页',
      :title =>  '%{firm_name}装修公司-杭州和家网装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司日记列表页',
      :title =>  '装修日记,装潢日记,点评日记-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司案例列表页',
      :title =>  '案例图片,装修图片,装潢图片-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司施工图片列表页',
      :title =>  '施工图片,装修故事,装潢故事-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司在建工地列表页',
      :title =>  '在建工地-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司设计师列表页',
      :title =>  '设计师-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司设计理念列表页',
      :title =>  '设计理念-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-价位',
      :title =>  '%{price}-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-现代简约',
      :title =>  '现代简约风格,现代简约装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-欧美式',
      :title =>  '欧美式风格,欧美式装修,欧式别墅装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-中式风格',
      :title =>  '中式风格装修,中式别墅装修设计-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-地中海',
      :title =>  '地中海风格,地中海装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-混搭',
      :title =>  '混搭风格,混搭装修方式-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-清包',
      :title =>  '清包,清包装修,装修方式价格-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-半包',
      :title =>  '半包,装修半包价格-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-全包',
      :title =>  '全包,装修全包价格-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-设计工作室',
      :title =>  '设计工作室-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-小户型',
      :title =>  '小户型装修,小户型复式装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-两房',
      :title =>  '两房装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-三房',
      :title =>  '三房装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-四房装修',
      :title =>  '四房装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-复式',
      :title =>  '复式装修,小复式装修,复式房|楼装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-别墅',
      :title =>  '别墅装修,别墅装潢设计-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:日记列表页',
      :title =>  '装潢日记,装潢公司日记-杭州和家网装修点评',
      :keywords => '装潢日记',
      :description => '和家网汇集杭州网友亲身装潢经历,记录最真实最完整的装潢日记和装饰日志,包含小户型,两房,三房,复式,别墅等多种房型的装潢装修过程,配套装潢案例图片和装潢施工图,让您不在现场也身临其境,学到更多装修知识.'
    },
     {
        :page_id => '杭州:装修点评:日记终端页',
        :title =>  '%{decoration_diary_name}-装修日记-杭州和家网装修点评',
        :keywords => '%{decoration_diary_name}',
        :description => ''
      },
    {
      :page_id => '杭州:装修点评:案例图片列表页',
      :title =>  '装潢图片,装潢效果图,装潢风格效果图大全-杭州和家网装修点评',
      :keywords => '装潢图片,装潢效果图',
      :description => '和家网汇集杭州装饰公司装潢图片,室内各种装潢效果图,包含不同风格的厨房,卧室,客厅等装潢装饰效果图大全,做为业主选择装潢设计公司的参考.各种装潢图片以装潢风格|装潢户型|装潢价格和装潢用途分类,尽可能帖近生活.'
    },
    {
      :page_id => '杭州:装修点评:案例图片终端页',
      :title =>  '%{case_name}-装修图片-杭州和家网装修点评',
      :keywords => '%{case_name}',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-现代简约',
      :title =>  '现代简约案例图片,现代简约装修图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-田园风格',
      :title =>  '田园风格案例图片,田园风格装修案例图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-欧美式',
      :title =>  '欧美式案例图片,欧美式装修图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-中式风格',
      :title =>  '中式风格案例图片,中式风格装修图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-地中海',
      :title =>  '地中海案例图片,地中海装修案例图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-混搭',
      :title =>  '混搭案例图片,混搭装修图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-小户型',
      :title =>  '小户型案例图片,小户型装修案例图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-别墅',
      :title =>  '别墅案例图片,别墅装修图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-复式',
      :title =>  '复式案例图片,复式装修案例图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:案例图片列表页-通用',
      :title =>  '%{condition}案例图片,%{condition}装修案例图片-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:施工图片列表页',
      :title =>  '装潢施工,家装施工图片大全-杭州和家网装修点评',
      :keywords => '装潢施工,家装施工',
      :description => '我们提供装修过程中的各种装潢施工图和家装施工图片,其中不乏家装施工大师的经典作品,符合您的各种装潢施工要求的家装施工图片大全,可以根据这些施工图来选择合适的装修施工团队.'
    },
    {
      :page_id => '杭州:装修点评:排行榜',
      :title =>  '装修公司排名,家装公司排名-杭州和家网装修点评',
      :keywords => '装修公司排名',
      :description => '和家网装修点评频道提供杭州装修公司排名,家装公司排名,是根据网友们的真实点评信息形成的装饰公司排名,方便您选择合适自己的装修公司!'
    },
    {
      :page_id => '杭州:装修点评:优惠券列表页',
      :title =>  '装潢优惠活动,装潢公司优惠活动-杭州和家网装修点评',
      :keywords => '装潢优惠,装潢公司优惠活动',
      :description => '和家网杭州站专业提供最新装潢优惠和装潢公司优惠活动信息,提供杭州全部装潢装修公司的优惠活动和优惠信息,让你装修装潢更优惠更省力!'
    },
    {
      :page_id => '杭州:装修点评:优惠券终端页',
      :title =>  '优惠信息-%{firm_name}装修公司',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:设计师终端页',
      :title =>  '%{designer_name}-家装设计师-杭州和家网装修点评',
      :keywords => '%{designer_name}',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:设计理念终端页',
      :title =>  '%{idea_name}-设计理念-杭州和家网',
      :keywords => '%{idea_name}',
      :description => ''
    },
    #新加的 
    {
      :page_id => '无锡:装修点评:公司列表页-田园风格',
      :title =>  '田园风格,田园风格装修-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-田园风格',
      :title =>  '田园风格,田园风格装修-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-田园风格',
      :title =>  '田园风格,田园风格装修-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-田园风格',
      :title =>  '田园风格,田园风格装修-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-田园风格',
      :title =>  '田园风格,田园风格装修-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '杭州:装修点评:公司列表页-地区',
      :title =>  '%{district}-装修公司列表-杭州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '上海:装修点评:公司列表页-地区',
      :title =>  '%{district}-装修公司列表-上海和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '宁波:装修点评:公司列表页-地区',
      :title =>  '%{district}-装修公司列表-宁波和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '苏州:装修点评:公司列表页-地区',
      :title =>  '%{district}-装修公司列表-苏州和家网装修点评',
      :keywords => '',
      :description => ''
    },
    {
      :page_id => '无锡:装修点评:公司列表页-地区',
      :title =>  '%{district}-装修公司列表-无锡和家网装修点评',
      :keywords => '',
      :description => ''
    }
  ]
  p "create #{html_metadata.size} rows"
  html_metadata.each_with_index do |html,index|
    HtmlMetadata.create(:url => "z.51hejia.com/#{html[:page_id]}",:page_id => html[:page_id],:title => html[:title],:keywords => html[:keywords],:description => html[:description])
  end
  p "create all ok!!!"
  p " end ...."
end