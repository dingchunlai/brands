# encoding: utf-8
# @author: Gimi Liang

class Ability::Permission < Hejia::Db::Hejia
  set_table_name 'ability_permissions'

  belongs_to :group,      :class_name => 'Ability::Permission::Group'
  has_many   :authorities, :class_name => 'Ability::Authority', :foreign_key => 'permission_id', :dependent => :destroy

  def action
    @action ||= read_attribute(:action).to_sym
  end

  def action=(action)
    @action = action.to_sym
    write_attribute :action, action.to_s
  end

  # subject_class 如果是大写字母开头的，则认为是常量；否则是Symbol。
  def subject_class
    @subject_class ||=
      begin
        klass = read_attribute(:subject_class)
        klass.to_s =~ /^[A-Z]/ ? klass.constantize : klass.to_sym
      end
  end

  # 如果subject_class不是一个常量，并且首字母大写的华，将会自动转为小写
  def subject_class=(klass)
    @subject_class = klass.is_a?(Module) ? klass : klass.to_s.sub(/^[A-Z]/) { |c| c.downcase }.to_sym
    write_attribute :subject_class, @subject_class.to_s
    @subject_class
  end

  def subject_conditions
    @subject_conditions ||=
      begin
        conditions = read_attribute(:subject_conditions)
        Yajl::Parser.parse conditions if conditions
      end
  end

  def subject_conditions=(subject_conditions)
    @subject_conditions = subject_conditions
    write_attribute :subject_conditions, Yajl::Encoder.encode(subject_conditions)
    subject_conditions
  end

  def subject_class_name
    subject_class.to_s
  end

  # 给某个角色授权此操作。
  def authorize(*roles)
    roles.flatten!
    roles.each { |role|
      role = role.to_s unless role.is_a?(String)
      authorities.create :role_name => role

    }
    self
  end

  def to_s
    s = ''
    s << "#{group.to_s}:" if group
    s << title
  end

  # 用于给Permission分组
  # 组是一个树型结构
  class Group < Hejia::Db::Hejia
    set_table_name 'ability_permission_groups'

    belongs_to :parent,   :class_name => self.name, :foreign_key => 'parent_id'
    has_many   :children, :class_name => self.name, :foreign_key => 'parent_id'

    has_many :permissions, :class_name => 'Ability::Permission'

    def <<(title)
      children.create :title => title
    end

    def to_s
      s = ''
      s << "#{parent.to_s}:" if parent
      s << title
    end
  end

end

__END__
SET NAMES utf8;

use 51hejia;

CREATE TABLE ability_permissions (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  action VARCHAR(255) NOT NULL,
  subject_class VARCHAR(255) NOT NULL,
  subject_conditions VARCHAR(500),
  title VARCHAR(255),
  group_id INTEGER
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX ability_permissions_group_id_index ON ability_permissions (group_id);

CREATE TABLE ability_permission_groups (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  parent_id INTEGER
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX ability_permission_groups_parent_id_index ON ability_permission_groups (parent_id);
