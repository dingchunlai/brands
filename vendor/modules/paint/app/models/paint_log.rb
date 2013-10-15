class PaintLog < Hejia::Db::Hejia
  belongs_to :item, :polymorphic => true
  belongs_to :paint_admin, :class_name => "PaintAdmin",  :foreign_key => "user_id"
  
  before_save :update_info
    
  def user_name
    paint_admin ? paint_admin.USERNAME : '管理员'
  end
  
   named_scope :by_all, lambda{ |params|
   conditions = []
   condition_params = []
   unless params[:user_id].blank?
     conditions << "user_id = ?"
     condition_params << params[:user_id]
   end
   unless params[:start_date].blank?
     conditions << "created_at >= ?"
     condition_params << "#{params[:start_date]} 00:00:00"
   end
   unless params[:end_date].blank?
     conditions << "created_at <= ?"
     condition_params << "#{params[:end_date]} 23:59:59"
   end
   {
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'created_at desc'        
   }
  }
  

  
  private
  def update_info
     self.user_id = Thread.current[:current_user].id if Thread.current[:current_user]
     if self.item_type == 'HejiaUserBbs'
       self.item_type = HejiaUserBbs.get_user(self.item_id).class.name
     end
  end

  
end
