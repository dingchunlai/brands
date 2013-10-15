module Hejia
  # 给Model提推广的功能。
  #
  # class Article < ActiveRecord::Base
  #   include Hejia::Promotable
  #
  #   promotion_name '文章'
  #
  #   promotion_method_alias :title, :title
  #   promotion_method_alias :description, :summary
  #   promotion_method_alias :url, :url
  # end
  #
  # Promotable.all #= {Article => '文章'}
  #
  # article.promotion(:title)
  # article.promotion(:url)
  #
  module Promotable
    class << self
      @@promotables = {}

      def included(mod)
        @@promotables[mod.name] = nil
        mod.extend ClassMethods
        mod.send :include, InstanceMethods
      end

      # 取得所有推广的Model
      def all
        @@promotables.inject({}) { |h, (k, v)| h[k] = v || k.constantize.human_name; h }
      end

      def register(mod)
        mod.send :include, self
      end

      # @private
      def update_name(model, name)
        @@promotables[model.name] = name
      end
    end

    module ClassMethods
      # 提供推广方法的别名
      def promotion_method_alias(promotion_method, method = nil)
        @promotion_method_alias ||= {}
        if method
          @promotion_method_alias[promotion_method] = method
        else
          @promotion_method_alias[promotion_method]
        end
      end

      # 指定model推广的名字
      # 默认为Model.human_name
      def promotion_name(name)
        Promotable.update_name self, name
      end
    end

    module InstanceMethods
      # 调用推广的方法。
      # 如果使用了promotion_method_alias，则使用别名方法；否则直接调用`method`。
      def promotion(method, *args, &block)
        send self.class.promotion_method_alias(method) || method, *args, &block
      end
    end
  end
end
