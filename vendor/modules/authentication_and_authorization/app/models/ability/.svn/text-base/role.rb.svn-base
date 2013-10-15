# encoding: utf-8
# @author: Gimi Liang

class Ability::Role
  attr_accessor :name

  def self.all_names
    ::Ability::User::External.roles + ::Ability::User::Internal.roles
  end

  def self.all
    all_names.map! { |name| new name }
  end

  def self.find_by_name(*names)
    roles = all_names.inject([]) { |roles, name|
      roles << new(name) if names.include?(name)
      roles
    }
    roles.size == 1 ? roles.first : roles
  end

  def initialize(name)
    self.name = name
  end

  def permissions
    ::Ability::Authority.all(:conditions => {:role_name => name}, :include => :permission).map! { |auth| auth.permission }
  end

  alias to_s name # ;)
end
