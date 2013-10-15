class AdminV2::ProductionCategoriesController < AdminV2Controller
  def index
    @name, @tag_id = params[:name], params[:tag_id].to_i
    @categories = ProductionCategory.with_name(@name).for_tag(@tag_id).paginate :include => [:tag], :page => page
  end

  def new
    @category = ProductionCategory.new
  end

  def create
    @category = ProductionCategory.new params[:production_category]

    if attributes = params[:attributes]
      attributes.each do |_, name|
        @category.attrs.build :name => name unless name.blank?
      end
    end

    if @category.save
      flash[:notice] = '产品类别添加成功'
      redirect_to :action => :index
    else
      flash[:alert] = '产品添加失败'
      render :action => :new
    end
  end

  def edit
    @category = ProductionCategory.find params[:id]
    render :action => :new
  end

  def update
    @category = ProductionCategory.find params[:id], :include => :attrs
    @category.attributes = params[:production_category]

    attributes = params[:attributes] || {}
    attribute_mapping = attributes.delete :mapping

    new_attributes = attributes.inject({}) { |h, (index, name)|
      h[index] = name unless name.blank?
      h
    }
    updated_attributes = attribute_mapping && attribute_mapping.inject({}) { |h, (index, attr_id)|
      h[attr_id.to_i] = new_attributes.delete index if new_attributes.key?(index)
      h
    }

    @category.attrs.each do |att|
      if name = updated_attributes.delete(att.id)
        att.update_attribute :name, name
      else
        att.destroy
      end
    end
    new_attributes.each do |_, name|
      @category.attrs.build :name => name
    end

    if @category.save
      flash[:notice] = '产品类别添加成功'
      redirect_to :action => :index
    else
      flash[:alert] = '产品添加失败'
      render :action => :new
    end
  end

  def destroy
    ProductionCategory.destroy params[:id]
    flash[:notice] = '产品类别已被删除'
    redirect_to :action => :index
  end
end
