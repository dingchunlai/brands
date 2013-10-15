module Admin::DistributorsHelper
  def fields_for_setting(setting, &block)
    new_or_existing = setting.new_record? ? 'new' : 'existing'
    prefix = "distributor_account[#{new_or_existing}_setting_attributes][]"
    fields_for(prefix, setting, &block)
  end
end