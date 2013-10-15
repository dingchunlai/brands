require 'yaml'

module Features
  # 保存、读取推广公司的信息
  class PromotedCompany
    
#     yaml format:

          
    # shanghai:
    #   201007:
    #     - id: 123
    #       image_url: http://xxx
    #     - id: 234
    #       image_url: http://xxx
    #   201008:
    #     - id: 345
    #       image_url: http://xxx
    # suzhou:
    #   201007:
    #     - id: 123
    #       image_url: http://xxx
    #     - id: 234
    #       image_url: http://xxx
    #   201008:
    #     - id: 345
    #       image_url: http://xxx
    def self.load_data_from_yaml(yaml)
      $redis.multi
      YAML.load(yaml).each do |city, issues|
        issues.each do |date, companies|
          list_key = "#{city}:#{date}"
          $redis.del list_key
          companies.each_with_index do |company, index|
            $redis.rpush list_key, company['id']
            $redis.set "firms:#{company['id']}:feature_image", company['image_url']
          end # companies
        end # issues
      end
      $redis.exec
    end

    # 找出某个城市，某一期的推广公司列表
    # @param [String] city 城市拼音
    # @param [Date, Time, Datetime, String] date 日期，可以是一个Date/Time对象，也可以是一个字符串：201007
    # @return [String] 公司id
    def self.find(city, date)
      date = date.strftime('%Y%m') if date.respond_to?(:strftime)
      $redis.lrange "#{city}:#{date}", 0, -1
    end

    # 给出公司id，找出公司的图片地址
    # @param [String, Integer
    def self.image_of(company_id)
      $redis.get "firms:#{company_id}:feature_image"
    end
  end
end
