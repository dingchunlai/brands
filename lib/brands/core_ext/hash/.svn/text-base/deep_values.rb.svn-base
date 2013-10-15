module Brands
  module CoreExt
    module Object
      alias deep_dup dup
    end

    module Array
      def deep_dup
        inject([]) { |a, e| a << e.deep_dup }
      end
    end

    module Hash
      def deep_values
        values.inject([]) { |a, v|
          if v.instance_of?(::Hash)
            a.concat v.deep_values
          else
            a << v
          end
        }
      end

=begin
      def deep_dup
        inject({}) { |h, (k, v)|
          h[k.deep_dup] = v.deep_dup
        }
      end
=end
    end
  end
end

#::Object.send :include, ::Brands::CoreExt::Object
#::Array.send  :include, ::Brands::CoreExt::Array
::Hash.send   :include, ::Brands::CoreExt::Hash
