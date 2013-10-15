class PrettyAdminController < ApplicationController

  class_inheritable_accessor :navigation_partial, :menu_partial

  def self.set_navigation_partial(partial)
    self.navigation_partial = partial
  end

  def self.set_menu_partial(partial)
    self.menu_partial = partial
  end

  protected

  def set_navigation_partial(partial)
    @navigation_partial = partial
  end

  def set_menu_partial(partial)
    @menu_partial = partial
  end

end
