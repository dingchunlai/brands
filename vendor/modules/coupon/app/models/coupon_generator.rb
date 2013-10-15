require 'rubygems'
require 'RMagick'
require 'singleton'
require 'date'
class CouponGenerator
  include Singleton
  include Magick

  # ==
  # canvas_option : 画布选项，长 宽 背景色
  #
  # ==
  @@config = {
    :icon_path => '', # endwith '/'
    :canvas_option => { :width => 430, :height => 240, :bgcolor => '#ffffff', :dpi => 300.0, :output_path => '', :output_format => 'png' },
    :horizontal_option => { :span => 5, :fill_color => '#0095a6' },
    :vertical_option => { :span => 18, :fill_color => '#0095a6' },
    :category_text_option => {
            :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            :font_family => 'Symbol',
            :font_weight => Magick::BoldWeight,
            :gravity => NorthWestGravity,
            :color => '#ffffff',
            :point_size => 12,
            :margin => {
                    :top => 10
            }
    },
    :coupon_image_option => {
        :margin => {
                :top => 0,
                :left => 5
        }
    },
    :logo_image_option => {
        :margin => {
                :left => 10,
                :top => 0
        }
    },
    :reach_text_option => {
        :max_width => 180, # * accroding the max logo pic Placehold width
        :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
        :font_family => 'Symbol',
        :font_weight => Magick::BoldWeight,
        :gravity => CenterGravity,
        :color => '#c71c25',
        :point_size => 16,
        :margin => {
                :top => -2
        }
    },
    :refund_image_option => {
        :max_width => 180, # * accroding the max logo pic Placehold width
        :spacing => 2,
        :width => 40, #num image width
        :height => 70, # num image height
        :margin => {
                :top => 2,
        }
    },
    :yuan_image_option => {
        :width => 40,
        :height => 40,
        :margin => {
                :left => -10 # must be negative number
        }
    },
    :valid_date_option => {
            :max_width => 180, # * accroding the max logo pic Placehold width
            :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            :font_family => 'Symbol',
            :font_weight => Magick::BoldWeight,
            :gravity => WestGravity,
            :color => '#c71c25',
            :point_size => 12,
            :margin => {
                    :top => 2,
                    :left => 5 # same as logo_image_option margin :left => 5
            }
    },
    :shop_name_option => {
            #max with = canvas.width - vertical.span - self.margin.left
            :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            :font_family => 'Symbol',
            :font_weight => Magick::BoldWeight,
            :gravity => WestGravity,
            :color => '#000000',
            :point_size => 12,
            :margin => {
                    :top => 30,
                    :left => 5  # same as coupon_image_option margin :left => 5
            }
    },
    :shop_address_option => {
            #max with = canvas.width - vertical.span - self.margin.left
            :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            :font_family => 'Symbol',
            :font_weight => Magick::BoldWeight,
            :gravity => WestGravity,
            :color => '#000000',
            :point_size => 12,
            :margin => {
                    :top => 2,
                    :left => 5 # same as coupon_image_option margin :left => 5
            }
    },
    :phone_icon_option => {
            :margin => {
                    :bottom => 23,
                    :left => 5 # same as coupon_image_option margin :left => 5

            }

    },
    :phone_number_option => {
            #max with = canvas.width - vertical.span - self.margin.left
            :font => '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            :font_family => 'Symbol',
            :font_weight => Magick::BoldWeight,
            :gravity => WestGravity,
            :color => '#000000',
            :point_size => 12,
            :margin => {
                    :bottom => 20,
                    :left => 10
            }
    },
    :district_icon_option => {
            :margin => {
                    :bottom => 23,
                    :right => 5

            }

    },

  }

  class << self
    def gen(coupon)
      self.instance.draw(coupon)
    end
  end

  def draw(coupon)
    raise ArgumentError, "Invalid arg" unless coupon.is_a?(Hash)
    @coupon = coupon
    # coupon_image_path category_text(汉字换行处理) logo_image_path
    # reach_value refund_value expire_date
    # shop_name shop_address
    canvas
    vertical_bar
    category_text
    horizontal_bar
    coupon_image
    logo_image
    reach_text
    refund_image
    valid_date
    shop_name
    shop_address
    phone_icon
    phone_number
    district_icon
    @canvas.write("mm.png")
  end

  def canvas
    @canvas = Image.new(@@config[:canvas_option][:width], @@config[:canvas_option][:height]){ self.background_color = @@config[:canvas_option][:bgcolor] }
#    @canvas = @canvas.resample(@@config[:canvas_option][:dpi],@@config[:canvas_option][:dpi]) if @@config[:canvas_option][:dpi]
  end

  def vertical_bar
    gc = Draw.new
    gc.stroke = 'none'
    gc.fill(@@config[:vertical_option][:fill_color])
    gc.rectangle(0, 0, @@config[:vertical_option][:span], @@config[:canvas_option][:height])
    gc.draw(@canvas)
  end

  def horizontal_bar
    gc = Draw.new
    gc.stroke = 'none'
    gc.fill(@@config[:vertical_option][:fill_color])
    gc.rectangle(0, @@config[:canvas_option][:height] - @@config[:horizontal_option][:span], @@config[:canvas_option][:width], @@config[:canvas_option][:height])
    gc.draw(@canvas)
  end

  def category_text
    gc = Draw.new
    gc.annotate(@canvas, 0, 0, (@@config[:vertical_option][:span] - @@config[:category_text_option][:point_size]) / 2, @@config[:category_text_option][:margin][:top], @coupon[:category_text]) {
      self.text_antialias(true)
      self.gravity = @@config[:category_text_option][:gravity]
      self.pointsize = @@config[:category_text_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:category_text_option][:color]
      self.font = @@config[:category_text_option][:font]
      self.font_weight = @@config[:category_text_option][:font_weight]
    }
  end

  def coupon_image
    # instance variable for logo and money text etc margin
    @coupon_image = ImageList.new(@coupon[:coupon_image_path]).first
    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:coupon_image_option][:margin][:left]
    y1 = @@config[:coupon_image_option][:margin][:top]
    x2 = @coupon_image.columns
    y2 = @coupon_image.rows
    gc.composite(x1, y1, x2, y2, @coupon_image)
    gc.draw(@canvas)
  end

  def logo_image
    @logo_image =  ImageList.new(@coupon[:logo_image_path]).first
    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:coupon_image_option][:margin][:left] + @coupon_image.columns + @@config[:logo_image_option][:margin][:left]
    y1 = @@config[:logo_image_option][:margin][:top]
    x2 = @logo_image.columns
    y2 = @logo_image.rows
    gc.composite(x1, y1, x2, y2, @logo_image)
    gc.draw(@canvas)
  end

  def reach_text
    gc_text = Draw.new
    @reach_text_image = Image.new( @@config[:reach_text_option][:max_width], @@config[:reach_text_option][:point_size] ) { self.background_color = 'transparent' }
    reach_text = "每满#{@coupon[:reach_value]}元抵"
    gc_text.annotate(@reach_text_image, 0, 0, 0, 0, reach_text) {
      self.text_antialias(true)
      self.gravity = @@config[:reach_text_option][:gravity]
      self.pointsize = @@config[:reach_text_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:reach_text_option][:color]
      self.font = @@config[:reach_text_option][:font]
      self.font_weight = @@config[:reach_text_option][:font_weight]
    }

    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:coupon_image_option][:margin][:left] + @coupon_image.columns + @@config[:logo_image_option][:margin][:left]
    half_l = (@logo_image.columns - @reach_text_image.columns).abs / 2
    if @logo_image.columns > @reach_text_image.columns
      x1 = x1 + half_l
    else
      x1 = x1 - half_l
    end
    y1 = @@config[:logo_image_option][:margin][:top] + @logo_image.rows + @@config[:reach_text_option][:margin][:top]
    x2 = @reach_text_image.columns
    y2 = @reach_text_image.rows
    gc.composite(x1, y1 , x2 ,y2, @reach_text_image)
    gc.draw(@canvas)
  end

  def refund_image
    refund_value = @coupon[:refund_value].to_s
    # add refund_value.length for spacing
    refund_image_width = refund_value.length * @@config[:refund_image_option][:spacing] + refund_value.length * @@config[:refund_image_option][:width] + @@config[:yuan_image_option][:width] + @@config[:yuan_image_option][:margin][:left]
    @refund_image = Image.new(refund_image_width, @@config[:refund_image_option][:height]) { self.background_color = 'transparent' }

    # add num image to @refund_image
    # limit all num image has the same width and height???
    num_list = refund_value.scan(/[0-9]/).collect { |num| "#{@@config[:icon_path]}#{num}.jpg" }
    num_list.each_with_index do |num_img, index|
      img = ImageList.new(num_img).first
      gc = Draw.new
      x1 = index * @@config[:refund_image_option][:width] + index * @@config[:refund_image_option][:spacing]
      y1 = 0
      x2 = img.columns
      y2 = img.rows
      gc.composite(x1, y1, x2, y2, img)
      gc.draw(@refund_image)
    end

    # add yuan image
    yuan_img = ImageList.new("#{@@config[:icon_path]}yuan.jpg").first
    gc_yuan = Draw.new
    x1 = num_list.size * @@config[:refund_image_option][:width] + (num_list.size - 1) * @@config[:refund_image_option][:spacing] + @@config[:yuan_image_option][:margin][:left]
    y1 = @@config[:refund_image_option][:height] - yuan_img.rows
    x2 = yuan_img.columns
    y2 = yuan_img.rows
    gc_yuan.composite(x1, y1, x2, y2, yuan_img)
    gc_yuan.draw(@refund_image)


    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:coupon_image_option][:margin][:left] + @coupon_image.columns + @@config[:logo_image_option][:margin][:left]
    half_l = (@logo_image.columns - @refund_image.columns).abs / 2
    if @logo_image.columns > @refund_image.columns
      x1 = x1 + half_l
    else
      x1 = x1 - half_l
    end
    y1 = @@config[:logo_image_option][:margin][:top] + @logo_image.rows + @@config[:reach_text_option][:margin][:top] + @reach_text_image.rows + @@config[:refund_image_option][:margin][:top]
    x2 = @refund_image.columns
    y2 = @refund_image.rows
    gc.composite(x1, y1 , x2 ,y2, @refund_image)
    gc.draw(@canvas)
  end

  def valid_date
    gc_text = Draw.new
    @date_text_image = Image.new( @@config[:valid_date_option][:max_width], @@config[:valid_date_option][:point_size] ) { self.background_color = 'transparent' }
    date_text = "有效期:截止#{@coupon[:expire_date].strftime("%Y年%m月%d日")}"
    gc_text.annotate(@date_text_image, 0, 0, 0, 0, date_text) {
      self.text_antialias(true)
      self.gravity = @@config[:valid_date_option][:gravity]
      self.pointsize = @@config[:valid_date_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:valid_date_option][:color]
      self.font = @@config[:valid_date_option][:font]
      self.font_weight = @@config[:valid_date_option][:font_weight]
    }

    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + (@@config[:coupon_image_option][:margin][:left] + @coupon_image.columns) + @@config[:valid_date_option][:margin][:left]
    y1 = (@@config[:logo_image_option][:margin][:top] + @logo_image.rows) +
             (@reach_text_image.rows + @@config[:reach_text_option][:margin][:top]) +
             (@refund_image.rows + @@config[:refund_image_option][:margin][:top]) +
             @@config[:valid_date_option][:margin][:top]
    x2 = @date_text_image.columns
    y2 = @date_text_image.rows
    gc.composite(x1, y1 , x2 ,y2, @date_text_image)
    gc.draw(@canvas)
  end

  def shop_name
    gc_text = Draw.new
    @shop_name_text_image = Image.new( @@config[:canvas_option][:width] - @@config[:vertical_option][:span] - @@config[:shop_name_option][:margin][:left], @@config[:shop_name_option][:point_size] + 2 ) { self.background_color = 'transparent' }
    name_text = "名 :  #{@coupon[:shop_name]}"
    gc_text.annotate(@shop_name_text_image, 0, 0, 0, 0, name_text) {
      self.text_antialias(true)
      self.gravity = @@config[:shop_name_option][:gravity]
      self.pointsize = @@config[:shop_name_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:shop_name_option][:color]
      self.font = @@config[:shop_name_option][:font]
      self.font_weight = @@config[:shop_name_option][:font_weight]
    }

    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:shop_name_option][:margin][:left]
    y1 = (@@config[:coupon_image_option][:margin][:top] + @coupon_image.rows) + @@config[:shop_name_option][:margin][:top]
    x2 = @shop_name_text_image.columns
    y2 = @shop_name_text_image.rows
    gc.composite(x1, y1 , x2 ,y2, @shop_name_text_image)
    gc.draw(@canvas)
  end

  def shop_address
    gc_text = Draw.new
    @shop_address_text_image = Image.new( @@config[:canvas_option][:width] - @@config[:vertical_option][:span] - @@config[:shop_address_option][:margin][:left], @@config[:shop_address_option][:point_size] + 2 ) { self.background_color = 'transparent' }
    address_text = "址 :  #{@coupon[:shop_address]}"
    gc_text.annotate(@shop_address_text_image, 0, 0, 0, 0, address_text) {
      self.text_antialias(true)
      self.gravity = @@config[:shop_address_option][:gravity]
      self.pointsize = @@config[:shop_address_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:shop_address_option][:color]
      self.font = @@config[:shop_address_option][:font]
      self.font_weight = @@config[:shop_address_option][:font_weight]
    }

    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:shop_address_option][:margin][:left]
    y1 = (@@config[:coupon_image_option][:margin][:top] + @coupon_image.rows) +
            (@shop_name_text_image.rows + @@config[:shop_name_option][:margin][:top]) +
            @@config[:shop_address_option][:margin][:top]
    x2 = @shop_address_text_image.columns
    y2 = @shop_address_text_image.rows
    gc.composite(x1, y1 , x2 ,y2, @shop_address_text_image)
    gc.draw(@canvas)
  end

  def phone_icon
    @phone_icon_image =  ImageList.new("#{@coupon[:icon_path]}phone.jpg").first
    gc = Draw.new
    x1 = @@config[:vertical_option][:span] + @@config[:phone_icon_option][:margin][:left]
    y1 = @@config[:canvas_option][:height] - @@config[:phone_icon_option][:margin][:bottom]
    x2 = @phone_icon_image.columns
    y2 = @phone_icon_image.rows
    gc.composite(x1, y1, x2, y2, @phone_icon_image)
    gc.draw(@canvas)
  end

  def phone_number
    gc_text = Draw.new
    @phone_number_text_image = Image.new( @@config[:canvas_option][:width] - @@config[:vertical_option][:span] - @@config[:phone_number_option][:margin][:left], @@config[:phone_number_option][:point_size] + 2 ) { self.background_color = 'transparent' }
    phone_number_text = "#{@coupon[:phone_number]}"
    gc_text.annotate(@phone_number_text_image, 0, 0, 0, 0, phone_number_text) {
      self.text_antialias(true)
      self.gravity = @@config[:phone_number_option][:gravity]
      self.pointsize = @@config[:phone_number_option][:point_size]
      self.stroke = 'none'
      self.fill = @@config[:phone_number_option][:color]
      self.font = @@config[:phone_number_option][:font]
      self.font_weight = @@config[:phone_number_option][:font_weight]
    }

    gc = Draw.new
    x1 = @@config[:vertical_option][:span] +
            (@phone_icon_image.columns + @@config[:phone_icon_option][:margin][:left]) +
            @@config[:phone_number_option][:margin][:left]
    y1 = @@config[:canvas_option][:height] - @@config[:phone_number_option][:margin][:bottom]
    x2 = @phone_number_text_image.columns
    y2 = @phone_number_text_image.rows
    gc.composite(x1, y1 , x2 ,y2, @phone_number_text_image)
    gc.draw(@canvas)
  end

  def district_icon
    @district_icon_image =  ImageList.new("#{@@config[:icon_path]}#{@coupon[:district_icon]}").first
    gc = Draw.new
    x1 = @@config[:canvas_option][:width] - @@config[:district_icon_option][:margin][:right] - @district_icon_image.columns
    y1 = @@config[:canvas_option][:height] - @@config[:district_icon_option][:margin][:bottom] - @district_icon_image.rows
    x2 = @district_icon_image.columns
    y2 = @district_icon_image.rows
    gc.composite(x1, y1, x2, y2, @district_icon_image)
    gc.draw(@canvas)
  end

end