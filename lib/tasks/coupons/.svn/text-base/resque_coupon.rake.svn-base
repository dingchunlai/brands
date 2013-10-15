require 'resque/tasks'

task "resque:setup" => :environment do
  require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'daemonize'))
  Process.daemon
end
