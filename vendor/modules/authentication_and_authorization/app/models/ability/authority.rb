# encoding: utf-8
# @author: Gimi Liang

class Ability::Authority < Hejia::Db::Hejia
  set_table_name 'ability_authorities'

  belongs_to :permission, :class_name => 'Ability::Permission'
end

__END__
SET NAMES utf8;

use 51hejia;

CREATE TABLE ability_authorities (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(255) NOT NULL,
  permission_id INTEGER NOT NULL
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX ability_authorities_role_name_index ON ability_authorities (role_name);
