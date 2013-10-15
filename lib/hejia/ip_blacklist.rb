# encoding: utf-8
# @author Gimi Liang

module Hejia
  class IpBlacklist
    def initialize(app)
      @app = app
      @backend = Backend::Database
    end

    def call(env)
      request = Rack::Request.new env
      if @backend.block?(request.request_method, request.ip)
        Rails.logger.debug "[IpBlacklist] blocked! #{request.ip} | #{request.request_method}"
        forbidden!
      else
        @app.call env
      end
    end

    private

    def forbidden!
      body = <<-_HTML_
<!doctype html>
<html lang="zh">
  <head>
    <meta charset="UTF-8">
    <title>和家网 - 禁止访问</title>
    <meta name="ROBOTS" content="NOINDEX,NOFOLLOW">
  </head>
  <body>
    <p>
      您已经被禁止执行这个操作。如有疑问，请拨打客服热线。
      点击<a href="javascript:window.history.back()">这里</a>返回之前访问的页面。
      点击<a href="http://www.51hejia.com">这里</a>访问和家网首页。
    </p>
  </body>
</html>
      _HTML_
      [
        403,
        {'Content-Type' => 'text/html', 'Content-Length' => body.bytesize.to_s},
        [body]
      ]
    end

    # ip黑名单后端的命名空间。
    # 每一个后端的实现，都必须要实现一个block?方法。该方法接受两个参数method和ip。
    # method是指访问通过的方法，如GET, POST等；ip就是访问的ip。
    # block?方法应该在ip被列入黑名单时，返回true；否则，返回false。
    module Backend
      # 把ip黑名单的信息保存在数据库的一个后端实现。
      class Database < Hejia::Db::Hejia

        # use 51hejia;
        #
        # CREATE TABLE ip_blacklist (
        #   ip INTEGER PRIMARY KEY,
        #   expires_on DATE,
        #   block_options TINYINT(1) DEFAULT 0,
        #   block_get     TINYINT(1) DEFAULT 0,
        #   block_head    TINYINT(1) DEFAULT 0,
        #   block_post    TINYINT(1) DEFAULT 0,
        #   block_put     TINYINT(1) DEFAULT 0,
        #   block_delete  TINYINT(1) DEFAULT 0,
        #   block_trace   TINYINT(1) DEFAULT 0,
        #   block_connect TINYINT(1) DEFAULT 0
        # ) ENGINE InnoDB CHARACTER SET utf8;

        set_table_name  'ip_blacklist'
        set_primary_key 'ip'

        def self.block?(method, ip)
          if record = find_by_ip(encode(ip))
            not record.can?(method)
          else
            false
          end
        end

        def self.encode(ip)
          ip.to_s.split('.').zip([24, 16, 8, 0]).inject(0) { |code, (seg, weight)| code + (seg.to_i << weight) }
        end

        def can?(method)
          !expires_on.nil? and expires_on < Time.zone.today or access_through?(method)
        end

        def ip=(ip)
          @ip = encode ip
          write_attribute @ip
        end

        private

        def access_through?(method)
          not read_attribute("block_#{method.to_s.downcase}")
        end

        def encode(ip)
          self.class.encode ip
        end
      end
    end
  end
end
