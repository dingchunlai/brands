namespace :top_ten_firms do
	desc "各块分类公司top10"
  task :firm=>:environment  do

    FENGLEI = {
      "8万以下" => "select id, name_abbr, praise as c from deco_firms where city=11910 and price=1 order by is_cooperation desc, praise desc limit 10",
      "8-15万" => "select id, name_abbr, praise as c from deco_firms where city=11910 and price=2 order by is_cooperation desc, praise desc limit 10",
      "15万以上" => "select id, name_abbr, praise as c from deco_firms where city=11910 and price in (3,4,5,6) order by is_cooperation desc, praise desc limit 10",
      "网友关注最多" => "select d.id, d.name_abbr, count(a.id) as c from deco_firms d,decoration_diaries c,decoration_diary_posts b,remarks a where d.city=11910 and c.deco_firm_id=d.id and c.is_verified = 1 and b.decoration_diary_id=c.id and a.resource_id=b.id and a.resource_type='DecorationDiaryPost' group by d.id order by d.is_cooperation desc, c desc limit 10",
      "活跃装修日记" => "select d.id, d.name_abbr, count(b.id) as c from deco_firms d,decoration_diaries c,decoration_diary_posts b where d.city=11910 and c.deco_firm_id=d.id and c.is_verified = 1 and b.decoration_diary_id=c.id and b.state=1 group by d.id order by d.is_cooperation desc, c desc limit 10",
      "一周评论最多" => "select d.id, d.name_abbr, count(c.id) as c from deco_firms d,remarks c where d.city=11910 and c.resource_type='DecoFirm' and c.resource_id=d.id and c.created_at >'#{7.days.ago.strftime("%Y-%m-%d")}' group by d.id order by d.is_cooperation desc, c desc limit 10",
      "施工排行" => "SELECT id, name_abbr, construction_praise as c FROM deco_firms where city=11910 order by is_cooperation desc, construction_praise desc limit 10",
            "区域" => {
              "徐汇" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12228 order by is_cooperation desc, pv_count desc limit 10",
              "普陀" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12227 order by is_cooperation desc, pv_count desc limit 10",
              "黄浦" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12225 order by is_cooperation desc, pv_count desc limit 10",
              "闵行" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12219 order by is_cooperation desc, pv_count desc limit 10",
              "静安" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12222 order by is_cooperation desc, pv_count desc limit 10",
              "杨浦" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12220 order by is_cooperation desc, pv_count desc limit 10",
              "长宁" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12214 order by is_cooperation desc, pv_count desc limit 10",
              "卢湾" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12210 order by is_cooperation desc, pv_count desc limit 10",
              "浦东" => "SELECT id, name_abbr, pv_count as c FROM deco_firms where district=12212 order by is_cooperation desc, pv_count desc limit 10"
            }
    }
    FENGLEI.each do |catalog, values|
      if values.class == Hash
        values.each do |district, value|
          if $redis.zrange("top_ten:firms:#{catalog}:#{district}", 0, 9).blank?
            @top_10_firms = DecoFirm.find_by_sql("#{value}")
            @top_10_firms.each do |firm|
              key = "top_ten:firms:#{catalog}:#{district}"
              $redis.zadd key, "#{firm.c}", firm.id
              $redis.set "firms:#{firm.id}:name", firm.name_abbr
              $redis.set "top_ten:firms:#{catalog}:#{district}：#{firm.id}:status", 0
            end
          else
            key = "top_ten:firms:#{catalog}:#{district}"
            p key
            @redis_firms = $redis.zrange("top_ten:firms:#{catalog}:#{district}", 0, 9).reverse
            $redis.del(key)
            @mysql_firms = DecoFirm.find_by_sql("#{value}")
            @mysql_firms.each_with_index do |firm, i|
              if @redis_firms.include?(firm.id.to_s)
                @redis_firms.each_with_index do |r, j|
                  if firm.id == r.to_i
                    $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", -1 if i - j > 0
                    $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 0 if i - j == 0
                    $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 1 if i - j < 0
                  end
                end
              else
                $redis.set "top_ten:firms:#{catalog}:#{district}：#{firm.id}:status", 1
              end
              $redis.zadd key, "#{firm.c}", firm.id
              $redis.set "firms:#{firm.id}:name", firm.name_abbr
            end
          end
        end
      else
        if $redis.zrange("top_ten:firms:#{catalog}", 0, 9).blank?
          @top_10_firms = DecoFirm.find_by_sql("#{values}")
          @top_10_firms.each do |firm|
            key = "top_ten:firms:#{catalog}"
            $redis.zadd key, "#{firm.c}", firm.id
            $redis.set "firms:#{firm.id}:name", firm.name_abbr
            $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 0
          end
        else
          key = "top_ten:firms:#{catalog}"
          p key
          @redis_firms = $redis.zrange("top_ten:firms:#{catalog}", 0, 9).reverse
          $redis.del(key)
          @mysql_firms = DecoFirm.find_by_sql("#{values}")
          @mysql_firms.each_with_index do |firm, i|
            $redis.zadd key, "#{firm.c}", firm.id
            $redis.set "firms:#{firm.id}:name", firm.name_abbr
            if @redis_firms.include?(firm.id.to_s)
              @redis_firms.each_with_index do |r, j|
                if firm.id == r.to_i
                  $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", -1 if i - j > 0
                  $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 0 if i - j == 0
                  $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 1 if i - j < 0
                end
              end
            else
              $redis.set "top_ten:firms:#{catalog}：#{firm.id}:status", 1
            end           
          end
        end
      end
    end
  end
end
    

   
