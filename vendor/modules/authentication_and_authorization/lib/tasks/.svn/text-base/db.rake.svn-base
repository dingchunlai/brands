namespace :auth do
  namespace :db do
    desc '初始化权限数据'
    task :seeds => :environment do

=begin
Extracted from:
    if user.has_role? "管理员"
      can :manage, :all
    elsif user.has_role? "审核员"
      can :read, :paint_workers
      can :create, :paint_workers
      can :update, :paint_workers
      can :applicants, :paint_workers
      can :accept, :paint_workers
      can :recycle, :paint_workers
      can :overrule, :paint_workers
      can :mamage, :contacts
      can :manage, :paint_cases
      can :manage, :export_xls
    elsif user.has_role? "评分员"
      can :manage, :paint_cases
    end
=end

      g = Ability::Permission::Group.create :title => '油漆工项目'
      p = g.permissions.create :title => '所有权限', :action => :manage, :subject_class => :all
      p.authorize '油漆工管理员'

      sub = g << '油漆工'
      [
        ['管理', :manage],
        ['查看', :read],
        ['添加', :create],
        ['更新', :update],
        ['查看申请列表', :applicants],
        ['批准申请', :accept],
        ['驳回申请', :overrule],
        ['恢复被删除的油漆工', :recycle]
      ].each do |title, action|
        p = sub.permissions.create :title => title, :action => action, :subject_class => :paint_workers
        p.authorize '油漆工审核员'
      end

      sub = g << '案例'
      p = sub.permissions.create :title => '管理', :action => :manage, :subject_class => :paint_cases
      p.authorize '油漆工审核员', '油漆工评分员'

      sub = g << '联系人'
      p = sub.permissions.create :title => '管理', :action => :manage, :subject_class => :paint_cases
      p.authorize '油漆工审核员'

      sub = g << '导出报表'
      p = sub.permissions.create :title => '管理', :action => :manage, :subject_class => :paint_cases
      p.authorize '油漆工审核员'
    end
  end
end
