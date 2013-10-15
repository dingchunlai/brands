namespace :coupon do
  namespace :printing do

    def truncate(text, length = 30, remove_html = true, truncate_string = "")
      hash = {'　'=>' ', '！'=>'!', '＂'=>'"', '＃'=>'#', '＄'=>'$', '％'=>'%', '＆'=>'&', '＇'=>'\'', '（'=>'(', '）'=>')', '＊'=>'*', '＋'=>'+', '，'=>',', '－'=>'-', '．'=>'.', '。' => '.', '、' => ',', '／'=>'/', '０'=>'0', '１'=>'1', '２'=>'2', '３'=>'3', '４'=>'4', '５'=>'5', '６'=>'6', '７'=>'7', '８'=>'8', '９'=>'9', '：'=>':', '；'=>';', '＜'=>'<', '＝'=>'=', '＞'=>'>', '？'=>'?', '＠'=>'@', 'Ａ'=>'A', 'Ｂ'=>'B', 'Ｃ'=>'C', 'Ｄ'=>'D', 'Ｅ'=>'E', 'Ｆ'=>'F', 'Ｇ'=>'G', 'Ｈ'=>'H', 'Ｉ'=>'I', 'Ｊ'=>'J', 'Ｋ'=>'K', 'Ｌ'=>'L', 'Ｍ'=>'M', 'Ｎ'=>'N', 'Ｏ'=>'O', 'Ｐ'=>'P', 'Ｑ'=>'Q', 'Ｒ'=>'R', 'Ｓ'=>'S', 'Ｔ'=>'T', 'Ｕ'=>'U', 'Ｖ'=>'V', 'Ｗ'=>'W', 'Ｘ'=>'X', 'Ｙ'=>'Y', 'Ｚ'=>'Z', '［'=>'[', '＼'=>'\\', '］'=>']', '＾'=>'^', '＿'=>'_', '｀'=>'`', 'ａ'=>'a', 'ｂ'=>'b', 'ｃ'=>'c', 'ｄ'=>'d', 'ｅ'=>'e', 'ｆ'=>'f', 'ｇ'=>'g', 'ｈ'=>'h', 'ｉ'=>'i', 'ｊ'=>'j', 'ｋ'=>'k', 'ｌ'=>'l', 'ｍ'=>'m', 'ｎ'=>'n', 'ｏ'=>'o', 'ｐ'=>'p', 'ｑ'=>'q', 'ｒ'=>'r', 'ｓ'=>'s', 'ｔ'=>'t', 'ｕ'=>'u', 'ｖ'=>'v', 'ｗ'=>'w', 'ｘ'=>'x', 'ｙ'=>'y', 'ｚ'=>'z', '｛'=>'{', '｜'=>'|', '｝'=>'}', '～'=>'~'}
      str  = text.gsub(/#{hash.keys.join("|")}/) { |c| hash[c] }
      str.gsub!(/<(.[^>]*)>/i, "") if remove_html
      return "" if str.empty?
      total_len = length * 2
      return str if str.length <= total_len

      s_ret = []
      len   = 0
      bytes = str.each_byte.collect { |b| b }

      while bytes.length > 0
        break if len > total_len
        num = bytes[0]
        if (num >= 224 and num <= 239) or (num >= 128 and num <= 191)
          len += 2
          s_ret << bytes[0..2].pack('c*')
          bytes.shift
          bytes.shift
          bytes.shift
        else
          if bytes[0] >=65 and bytes[0] <= 90
            len += 2
          else
            len += 1
          end
          s_ret << bytes[0].chr
          bytes.shift
        end
      end

      tmp = s_ret.join("")
      s_ret.pop if tmp.length > total_len
      s_ret.join("") + truncate_string
    end

    desc 'get all coupons by city and sort by industry and brand'
    task :list => :environment do
      city                 = City.find_by_pinyin(ENV['CITY'] || 'shanghai')
      city_id              = city.id

      addr_with_market     = ENV['MADDR'] || true
      category_sort        = [["地板", 42099], ["卫浴", 42100], ["橱柜", 42103], ["厨电", 42096], ["瓷砖", 44578], ["门窗", 44579], ["油漆涂料", 42093], ["壁纸／背景墙", 44580], ["吊顶", 43230], ["灯具", 44581], ["辅材", 44582], ["五金", 44583], ["楼梯", 44584], ["水处理", 42106], ["采暖", 44585], ["中央空调", 42889], ["家电", 44586], ["智能家居", 44587], ["家具", 42891], ["布艺", 44588], ["饰品", 44589], ["装修公司", 44590]]
      industry_hash        = {
          42099 => '地板',
          42100 => '卫浴',
          42103 => '橱柜',
          42096 => '厨电',
          44578 => '瓷砖',
          44579 => '门窗',
          42093 => '油漆涂料',
          44580 => '壁纸／背景墙',
          43230 => '吊顶',
          44581 => '灯具',
          44582 => '辅材',
          44583 => '五金',
          44584 => '楼梯',
          42106 => '水处理',
          44585 => '采暖',
          42889 => '中央空调',
          44586 => '家电',
          44587 => '智能家居',
          42891 => '家具',
          44588 => '布艺',
          44589 => '饰品',
          44590 => '装修公司'
      }
      industry_sort        = [42099, 42100, 42103, 42096, 44578, 44579, 42093, 44580, 43230, 44581, 44582, 44583, 44584, 42106, 44585, 42889, 44586, 44587, 42891, 44588, 44589, 44590]
      coupons              = Coupon.find(
          :all,
          :select     => "coupons.tag_id, 51hejia.HEJIA_TAG.TAGNAME as tag_name, coupons.id, coupons.code, coupons.shop_id, coupons.commission, coupons.discount_amount, coupons.return_amount, product_brands.name_zh, distributor_shops.address",
          :conditions => ["coupons.city_id = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? ", city_id, Time.zone.today, Time.zone.today],
          :joins      => " join product_brands on product_brands.id = coupons.brand_id "\
                  " join distributor_shops on distributor_shops.id = coupons.shop_id "\
                  " join 51hejia.HEJIA_TAG on 51hejia.HEJIA_TAG.TAGID = coupons.tag_id ",
          :order      => "coupons.tag_id desc, LOWER(product_brands.initial) asc, (coupons.return_amount / coupons.discount_amount) desc"
      )

      coupon_industry_hash = coupons.group_by(&:tag_id)
      coupons              = []
      industry_sort.each do |industry_id|
        coupons.concat(coupon_industry_hash[industry_id]) if coupon_industry_hash[industry_id]
      end

      # 印刷 文字长度限制
      brand_len    = 5
      industry_len = 4
      address_len  = 16
      summary_len  = 14
      headers      = %w(ID 编号 行业 品牌 地址 抵用金额) # 是否佣金券 行业超长 品牌超长 地址超长 抵用金额过长

      coupons.collect! { |coupon|

        address = coupon.address
        if addr_with_market == true
          shop = Distributor::Shop.find(coupon.shop_id)
          if shop.market_shop_id.nil?
            address = shop.address
          else
            market_shop = MarketShop.find(shop.market_shop_id)
            market      = market_shop.market
            address     = "#{market.name}(#{shop.address})"
          end
        end

        {:coupon_id => coupon.id, :commission => (coupon.commission > 0), :code => coupon.code.strip, :brand => coupon.name_zh.strip, :industry => coupon.tag_name.gsub("／", '').gsub("/", "").strip, :address => address.strip, :summary => "现金券#{coupon.return_amount}元(满#{coupon.discount_amount}元使用)"}
      }

      csv_data = FasterCSV.generate do |csv|
        csv << headers
        coupons.each do |item|
          row = []
          row << item[:coupon_id]
          row << item[:code]
          row << item[:industry]
          row << item[:brand]
          row << item[:address]
          row << item[:summary]
          row << (item[:commission] ? "是" : "否")

          # 行业超长 品牌超长 地址超长 抵用金额过长
#        t_industry = truncate(item[:industry], industry_len)
#        t_brand = truncate(item[:brand], brand_len)
#        t_address = truncate(item[:address], address_len)
#        t_summary = truncate(item[:summary], summary_len)
#        row << (item[:industry].length <= t_industry.length).to_s
#        row << (item[:brand].length <= t_brand.length).to_s
#        row << (item[:address].length <= t_address.length).to_s
#        row << (item[:summary].length <= t_summary.length).to_s

          csv << row
        end

        # 补上行业现金券数据
        industry_sort.each do |industry_id|
          if coupon_industry_hash[industry_id]
            row = []
            row << industry_hash[industry_id]
            row << coupon_industry_hash[industry_id].size
            (headers.size - 2).times { row << "-" }
            csv << row
          end
        end

      end

      File.open("#{ENV['HOME']}/Desktop/hejia_printing#{city.name}.csv", 'w') { |f| f.write(csv_data) }
      puts "ok"

    end

    desc 'get all coupons by city and sort by market sorts'
    task :list_market => :environment do
      # 地板,卫浴,橱柜,厨电,瓷砖,门窗,油漆涂料,壁纸／背景墙,吊顶,灯具,辅材,五金,楼梯,水处理,采暖,中央空调,家电,智能家居,家具,布艺,饰品,装修公司
      #category_sort = [["地板", 42099], ["卫浴", 42100], ["橱柜", 42103], ["厨电", 42096], ["瓷砖", 44578], ["门窗", 44579], ["油漆涂料", 42093], ["壁纸／背景墙", 44580], ["吊顶", 43230], ["灯具", 44581], ["辅材", 44582], ["五金", 44583], ["楼梯", 44584], ["水处理", 42106], ["采暖", 44585], ["中央空调", 42889], ["家电", 44586], ["智能家居", 44587], ["家具", 42891], ["布艺", 44588], ["饰品", 44589], ["装修公司", 44590]]
      category_sort          = [["地板", 42099], ["卫浴", 42100], ["橱柜", 42103], ["厨电", 42096], ["瓷砖", 44578], ["门窗", 44579], ["油漆涂料", 42093], ["壁纸／背景墙", 44580], ["吊顶", 43230], ["灯具", 44581], ["辅材", 44582], ["五金", 44583], ["楼梯", 44584], ["水处理", 42106], ["采暖", 44585], ["中央空调", 42889], ["家电", 44586], ["智能家居", 44587], ["家具", 42891], ["布艺", 44588], ["饰品", 44589], ["装修公司", 44590]]
      industry_sort          = [42099, 42100, 42103, 42096, 44578, 44579, 42093, 44580, 43230, 44581, 44582, 44583, 44584, 42106, 44585, 42889, 44586, 44587, 42891, 44588, 44589, 44590]
      #[2, 1, 7, 9, 8, 11, 12, 3, 20, 22, 37, 29, 18, 28, 31, 35, 25, 26, 34, 33, 17, 36, 21, 99, 16, 5]
      city                 = City.find_by_pinyin(ENV['CITY'] || 'shanghai')
      city_id              = city.id
#华夏：107，好艺家115，嘉饰茂116，红星团结店110   无锡 [107, 115, 116, 110]
      market_shop_ids        = [2, 1, 7, 9, 8, 11, 12, 3, 20, 22, 37, 29, 18, 28, 31, 35, 25, 26, 34, 33, 17, 36, 21, 99, 16, 5]
      coupons_by_market_shop = []
      market_shop_ids.each do |ms_id|
        mshop                = MarketShop.find(ms_id, :include => :market)
        dshop_ids            = Distributor::Shop.find(:all, :conditions => ["market_shop_id = ?", mshop.id], :select => "id", :order => 'id asc').map(&:id)
        coupons              = Coupon.find(
            :all,
            :select     => "coupons.tag_id, 51hejia.HEJIA_TAG.TAGNAME as tag_name, coupons.code, coupons.shop_id, coupons.id, coupons.commission, coupons.discount_amount, coupons.return_amount, product_brands.name_zh, distributor_shops.address",
            :conditions => ["coupons.city_id = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and shop_id in (?)", city_id, Time.zone.today, Time.zone.today, dshop_ids],
            :joins      => " join product_brands on product_brands.id = coupons.brand_id "\
                  " join distributor_shops on distributor_shops.id = coupons.shop_id "\
                  " join 51hejia.HEJIA_TAG on 51hejia.HEJIA_TAG.TAGID = coupons.tag_id ",
            :order      => "coupons.commission desc, coupons.tag_id desc, LOWER(product_brands.initial) asc, (coupons.return_amount / coupons.discount_amount) desc"
        )

        coupon_industry_hash = coupons.group_by(&:tag_id)
        coupons              = []
        industry_sort.each do |industry_id|
          coupons.concat(coupon_industry_hash[industry_id]) if coupon_industry_hash[industry_id]
        end

        coupons.collect! { |coupon|
          shop    = Distributor::Shop.find(coupon.shop_id)

          if shop.market_shop_id.nil?
            address = shop.address
          else
            market_shop = MarketShop.find(shop.market_shop_id)
            market      = market_shop.market
            address     = "#{market.name}(#{shop.address})"
          end


          {:commission => (coupon.commission > 0), :code => coupon.code, :brand => coupon.name_zh, :industry => coupon.tag_name, :address => address, :summary => "现金券#{coupon.return_amount}元(满#{coupon.discount_amount}元使用)", :id => coupon.id}
        }
        coupons_by_market_shop << ["#{mshop.market.name}$#{mshop.name}$#{mshop.id}", coupons]
      end #market shops each

      unless ENV['ONLY']
        csv_headers = %w(卖场 分店 券编号 行业 品牌 地址 满抵金额 佣金券 券ID)
        csv_data    = FasterCSV.generate do |csv|
          csv << csv_headers
          coupons_by_market_shop.each do |ary_item|
            key, value = ary_item
            market_name, market_shop_name, market_shop_id = key.split("$")
            value.each do |item|
              row = []
              row << market_name
              row << market_shop_name
              row << item[:code]
              row << item[:industry]
              row << item[:brand]
              row << item[:address]
              row << item[:summary]
              row << (item[:commision] ? "是" : "否")
              row << item[:id]
              csv << row
            end # value
          end # each

          # 添加数量
          csv << %w(卖场 分店 券数量 - - - - -)
          coupons_by_market_shop.each do |ary_item|
            key, value = ary_item
            market_name, market_shop_name, market_shop_id = key.split("$")
            row = []
            row << market_name
            row << market_shop_name
            row << value.size
            row << "-"
            row << "-"
            row << "-"
            row << "-"
            row << "-"
            csv << row
          end
        end #generate

        File.open("#{ENV['HOME']}/Desktop/hejia_printing#{city.name}.csv", "w") { |f| f.write(csv_data) }
      else
        csv_headers = %w(卖场 分店 券数量)
        csv_data    = FasterCSV.generate do |csv|
          csv << csv_headers
          coupons_by_market_shop.each do |ary_item|
            key, value = ary_item
            market_name, market_shop_name, market_shop_id = key.split("$")
            row = []
            row << market_name
            row << market_shop_name
            row << value.size
            csv << row
          end
        end
        File.open("#{ENV['HOME']}/Desktop/#{city.pinyin}_coupons_count.csv", "w") { |f| f.write(csv_data) }
      end

      puts "ok"
    end

    desc 'get coupons by ids'
    task :coupons_by_ids => :environment do
      ids     = ENV['IDS']
      city_id = 1
      coupons = Coupon.find(
          :all,
          :select     => "coupons.tag_id, coupons.id, 51hejia.HEJIA_TAG.TAGNAME as tag_name, coupons.code, coupons.shop_id, coupons.commission, coupons.discount_amount, coupons.return_amount, product_brands.name_zh, distributor_shops.address",
          :conditions => ["coupons.city_id = ? and coupons.id in (?)", city_id, ENV["IDS"].split("-")],
          :joins      => " join product_brands on product_brands.id = coupons.brand_id "\
                  " join distributor_shops on distributor_shops.id = coupons.shop_id "\
                  " join 51hejia.HEJIA_TAG on 51hejia.HEJIA_TAG.TAGID = coupons.tag_id ",
          :order      => "coupons.id asc"
      )

      coupons.collect! { |coupon|
        shop    = Distributor::Shop.find(coupon.shop_id)
        address = coupon.address
        if shop.market_shop_id.nil?
          address = shop.address
        else
          market_shop = MarketShop.find(shop.market_shop_id)
          market      = market_shop.market
          address     = "#{market.name}(#{shop.address})"
        end

        {:coupon_id => coupon.id, :commission => (coupon.commission > 0), :code => coupon.code, :brand => coupon.name_zh, :industry => coupon.tag_name, :address => address, :summary => "凭券满#{coupon.discount_amount}(抵用#{coupon.return_amount}元)"}
      }

      csv_headers = %w(卖场 分店 券编号 行业 品牌 地址 满抵金额 佣金券 券ID)
      csv_data    = FasterCSV.generate do |csv|
        csv << csv_headers
        coupons.each do |item|
          row = []
          row << "--"
          row << item[:coupon_id]
          row << item[:code]
          row << item[:industry]
          row << item[:brand]
          row << item[:address]
          row << item[:summary]
          row << (item[:commision] ? "是" : "否")
          row << item[:id]
          csv << row
        end # value
      end #generate
      File.open("tmp/shanghai_all_printing_coupons_append.csv", "w") { |f| f.write(csv_data) }
      puts "ok"
    end


    desc 'get test'
    task :test => :environment do
      codes_file = ENV["FILE"]
      codes = File.read(codes_file).split("\n")
      ids = codes.collect { |code|
        if coupon = Coupon.find(:first, :conditions => ["code = ?", code.gsub("\r", '')])
          coupon.id
        else
          puts "#{code} error"
        end
      }
      puts ids.join("\n")
    end
    
  end
end
