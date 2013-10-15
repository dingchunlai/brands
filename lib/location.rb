# encoding: utf-8

# To use this module, extend a class with it.
# @example
#   class City
#     extend Location
#   end
# @author 梁智敏
module Location
  @@default_region = 'china'.freeze
  @@whole = {
    'china' => ['quanguo', '全国']
  }
  
  REGION = {
    "华中" => ["河南", "湖北", "湖南"],
    "华东" => ["安徽 ", "江苏", "江西", "上海", "浙江"],
    "华南" => ["福建", "广西", "广东", "海南", "云南"],
    "华西" => ["贵州", "四川", "重庆"],
    "华北" => ["河北", "北京", "山东", "山西"],
    "东北" => ["黑龙江", "辽宁", "吉林"],
    "西北" => ["甘肃 ", "内蒙", "宁夏", "青海", "陕西", "新疆"]
  }
  
  #返回省份对应的地区的hash
  def region_for_province
    province_region = []
    REGION.each do |key, values|
      values.each do |v|
        province_region << [v, key]
      end
    end
    province_region.flatten!
    Hash[*province_region]
  end
  
  #把汉字转化为拼音
  def pinyin chinese
    py = ChineseDictionary.pinyin_for chinese
    py = py + '1' if chinese == '山西'
    py
  end
    
  # 设置/获取上级地区的类
  def superior(superior = nil)
    if superior
      if @superior
        remove_method superior_alias_method_name(:set)
        remove_method superior_alias_method_name(:get)
      end
      @superior = superior.is_a?(Module) && superior || superior.to_s.camelize.constantize
      instance_eval <<-_CODE_
        def #{superior_alias_method_name :set}(code, superior_code, region = @@default_region)
          set_superior_for code, superior_code, region
        end

        def #{superior_alias_method_name :get}(code, region = @@default_region)
          superior_of code, region
        end
      _CODE_
    end
    @superior
  end

  # 给某个地区设定上级地区。
  # @param [String] code 要设定上级地区的地区的代号
  # @param [String[ superior_code 上级地区的代号
  # @param [String] region 区域
  def set_superior_for(code, superior_code, region = @@default_region)
    check_existence! code, region
    superior.check_existence! superior_code, region
    $redis.set superior_key(code, region), superior_code
    superior.add_inferiors_to superior_code, code unless superior.has?(superior_code, code)
  end

  # 取得某个地区的上级地区。
  # @param [String] code 下级地区的代号
  # @param [String] region 区域
  # @return [Hash] 上级地区信息
  def superior_of(code, region = @@default_region)
    superior = {:code => $redis.get(superior_key(code, region))}
    superior.update :name => self.superior.name_for_code(superior[:code]) if superior[:code]
  end

  # 判断一个下级地区是否属于了指定的上级地区。
  # @param [String] inferior_code 下级地区代号
  # @param [String] superior_code 上级地区代号
  def belongs_to?(inferior_code, superior_code, region = @@default_region)
    $redis.get(superior_key(inferior_code, region)) ==  superior_code
  end

  # 设置/获取下级地区的类
  def inferior(inferior = nil)
    if inferior
      if @inferior
        remove_method inferior_alias_method_name(:set)
        remove_method inferior_alias_method_name(:get)
      end
      @inferior = inferior.is_a?(Module) && inferior || inferior.to_s.camelize.constantize
      instance_eval <<-_CODE_
        def #{inferior_alias_method_name :set}(code, inferior_codes, region = @@default_region)
          add_inferiors_to code, inferior_codes, region
        end

        def #{inferior_alias_method_name :get}(code, region = @@default_region)
          inferiors_of code, region
        end
      _CODE_
    end
    @inferior
  end

  # 给某一个上级地区添加下级地区。
  # @param [String] code 上级地区的代号
  # @param [Array<String>, String] inferior_codes 一个下级地区的代号，或一个下级地区代号的数组
  # @param [String] region 区域 
  def add_inferiors_to(code, inferior_codes, region = @@default_region)
    check_existence! code, region
    Array(inferior_codes).each do |inferior_code|
      inferior.check_existence! inferior_code, region
      $redis.sadd inferiors_key(code, region), inferior_code
      inferior.set_superior_for inferior_code, code unless inferior.belongs_to?(inferior_code, code)
    end
  end


  # 返回某一上级地区的所有下级地区。
  # @param [String] code 上级地区的代号
  # @param [String] region 区域 
  # @return Array<Array<String, String>> 从属地区数组
  def inferiors_of(code, region = @@default_region)
    codes = $redis.smembers inferiors_key(code, region)
    codes.empty? && [] || inferior.find(codes, :sort => true)
  end

  # 判断一个上级地区是否包含了指定的下级地区。
  # @param [String] superior_code 上级地区代号
  # @param [String] inferior_code 下级地区代号
  def has?(superior_code, inferior_code, region = @@default_region)
    $redis.sismember inferiors_key(superior_code, region), inferior_code
  end

  # 返回所有地区（包括代号和名称）
  # @param [Hash] options 各种选项
  # @option options [String] :region 地区，默认'china'
  # @option options [Boolean] :reverse 是否取反。如果是true，返回的hash将是{name => code}。默认是{code => name}。
  # @option options [Boolean] :without_whole 是否去除全国。默认false。
  # @option options [Boolean] :sort 是否排序（按code递增排序）
  # @return options [Hash, Array[Array]] 如果指定了sort，返回一个二维数组；否则返回一个Hash。
  def all(options = nil)
    region = options.try(:[], :region) || @@default_region
    reverse = options.try(:[], :reverse)

    all   = $redis.hgetall(key(region, reverse)) || {}
    index = reverse ? 1 : 0
    all   = all.to_a.sort! { |a, b| a[index] <=> b[index] } if options.try(:[], :sort)

    unless options.try(:[], :without_whole) || (whole = @@whole[region]).blank?
      if all.is_a?(Array)
        all.unshift [whole[index], whole[index - 1]]
      else
        all.update whole[index] => whole[index - 1]
      end
    end

    all
  end

  # 返回所有指定的code的地区。
  # @return [Array<Array<String, String>>] 地区数组
  def find(*codes)
    options = codes.last.is_a?(Hash) ? codes.pop : nil
    region  = options.try(:[], :region) || @@default_region
    codes.flatten!
    found = codes.zip $redis.hmget(key(region), *codes)
    found = found.to_a.sort! { |a, b| a[0] <=> b[0] } if options.try(:[], :sort)
    found
  end

  # 根据地区代号，返回地区的名称。
  # @param [String] code 地区代号
  # @param [String] region 地区，默认'china'
  # @return [String] 地区名称
  def name_for_code(code, region = @@default_region)
    name = $redis.hget key(region), code
    unless name
      whole = @@whole[region]
      name = whole[1] if whole[0] == code
    end
    name
  end

  # 根据地区名称，返回地区的代号。
  # @param [String] name 地区代号
  # @param [String] region 地区，默认'china'
  # @return [String] 地区代号
  def code_for_name(name, region = @@default_region)
    code = $redis.hget(key(region, true), name)
    unless code
      whole = @@whole[region]
      code = whole[0] if whole[1] == name
    end
    code
  end

  # 添加一个地区。
  # @param [String] code 地区代号
  # @param [String] name 地区名称
  # @param [Hash] options 其它选项参数
  # @option options [String] :region 地区
  # @option options [String] :superior 上级地区
  # @return [City] 返回City本身
  def add(code, name, options = nil)
    region   = options.try(:[], :region) || @@default_region
    superior = options.try(:[], :superior)

    unless @@whole[region][0] == code
      $redis.multi do
        $redis.hset key(region), code, name
        $redis.hset key(region, true), name, code
      end
      
      self.superior.add_inferiors_for superior, code if superior
    end
    self
  end

  # 根据代号，删除一个地区。
  # @param [String] code 地区代号
  # @param [String] region 地区，默认'china'
  # @return [City] 返回City本身
  def del(code, region = @@default_region)
    unless @@whole[region][0] == code
      name = name_for_code code
      $redis.hdel key(region), code
      $redis.hdel key(region, true), name

      superior and superior = superior_of(code) and remove_from_superior(code, superior[:code], region)
      inferior and inferiors_of(code).each { |inferior| remove_inferior code, inferior[0], region }
    end
    self
  end

  # 把一个下级地区，从它的上级地区的关系中脱离。
  # @param [String] inferior_code
  def remove_from_superior(inferior_code, superior_code, region = @@default_region)
    $redis.del superior_key(inferior_code, region)
    superior.has?(superior_code, inferior_code, region) and
      superior.remove_inferior(superior_code, inferior_code, region)
  end

  def remove_inferior(superior_code, inferior_code, region = @@default_region)
    $redis.srem inferiors_key(superior_code, region), inferior_code
    inferior.belongs_to?(inferior_code, superior_code, region) and
      inferior.remove_from_superior(inferior_code, superior_code)
  end

  # 返回现有的地区数
  # @param [String] region 地区，默认'china'
  # @return [Integer] 地区数
  def count(region = @@default_region)
    $redis.hlen(key(region)) + (@@whole[region] ? 1 : 0)
  end

  # 返回所有地区名称
  # @param [String] region 地区，默认'china'
  def names(region = @@default_region)
    names = $redis.hkeys key(region, true)
    if whole = @@whole[region]
      names.unshift whole[1]
    end
    names
  end

  # 返回所有地区代号
  # @param [String] region 地区，默认'china'
  def codes(region = @@default_region)
    codes = $redis.hkeys key(region)
    if whole = @@whole[region]
      codes.unshift whole[0]
    end
    codes
  end

  # 返回“全国”的代码和名称。
  # @param [String] region 地区，默认'china'
  def the_whole_contry(region = @@default_region)
    @@whole[region]
  end

  # 验证某一个代码的地区是否存在，不存在则抛出一场。
  # @return true
  # @raise NameError
  def check_existence!(code, region = @@default_region)
    $redis.hexists(key(region), code) or
    raise NameError, %'There is no "#{code}" in #{self}.'
  end

  private # ==================================================================

  def superior_alias_method_name(type)
    case type
    when :set
      "set_#{normalize_name @superior, false}_for"
    when :get
      "#{normalize_name @superior, false}_of"
    end
  end

  def inferior_alias_method_name(type)
    case type
    when :set
      "add_#{normalize_name @inferior}_to"
    when :get
      "#{normalize_name @inferior}_of"
    end
  end

  def normalize_name(object, pluralize = true)
    name = object.name.underscore
    pluralize ? name.pluralize : name
  end

  # redis的key值
  def key(region, reverse = false)
    "#{normalize_name self}:#{region}#{':reverse' if reverse}"
  end

  def superior_key(code, region)
    "#{normalize_name self}:#{region}:#{code}:#{normalize_name @superior, false}"
  end

  def inferiors_key(code, region)
    "#{normalize_name self}:#{region}:#{code}:#{normalize_name @inferior}"
  end
end
