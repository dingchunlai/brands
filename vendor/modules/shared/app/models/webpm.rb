# encoding: utf-8

class Webpm < Hejia::Db::Hejia
  self.table_name = "radmin_webpms"
end

__END__
# == Schema Information
# Schema version: 11
#
# Table name: radmin_webpms
#
#  id          :integer(11)     not null, primary key
#  keyword     :string(127)
#  value       :string(127)
#  sort        :integer(127)
#  description :string(127)
#  cdate       :datetime
#  udate       :datetime
