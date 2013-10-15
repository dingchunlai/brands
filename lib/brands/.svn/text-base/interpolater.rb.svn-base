module Brands
  module Interpolater
    @@match = /(\\)?(\{([^\}]+)\})/
    module_function
    def interpolate(text, values)
      text.gsub(@@match) { $1 ? $2 : values[$3.to_sym] }
    end
  end
end
