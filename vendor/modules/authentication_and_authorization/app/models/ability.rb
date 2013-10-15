# encoding: utf-8
# @author: Gimi Liang

class Ability

  #autoload :Permission, File.expand_path('../ability/permission', __FILE__)
  #autoload :Role,       File.expand_path('../ability/role',       __FILE__)
  #autoload :User,       File.expand_path('../ability/user',       __FILE__)
  # 如果使用autoload，开发模式下，第一次是正确的，第二次访问，User就会变成app/models/user.rb里面那个了！
  require_or_load File.expand_path('../ability/permission', __FILE__)
  require_or_load File.expand_path('../ability/role',       __FILE__)
  require_or_load File.expand_path('../ability/user',       __FILE__)

  include CanCan::Ability

  def initialize(user)
    user = ::Ability::User.new(user)
    user.permissions.each do |permission|
      can permission.action, permission.subject_class, permission.subject_conditions
    end

=begin
    # 用哪一种方式，主要是看效率
    user = Ability::User.new(user)
    can do |action, subject_class, subject|
      user.permissions.find_all_by_action(action).any do |permission|
        permission.subject_class == subject_class.to_s &&
          (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
      end
    end
=end
  end

end
