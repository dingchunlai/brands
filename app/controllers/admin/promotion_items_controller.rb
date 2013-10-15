class Admin::PromotionItemsController < AdminController

  def index
    code = params[:code]
    @collection = PromotionCollection.find_by_code(code)
    item_id = params[:item_id].to_i
    if item_id > 0
      @item = PromotionItem.find(item_id)
    else
      @item = PromotionItem.new
    end
    @resource = @item.resource_id.to_i>0?GeneralResource.find(@item.resource_id):GeneralResource.new if @collection.item_type=="GeneralResource"
    @items = PromotionCollection.all_items_for(code)
  end

  def create
    @item = PromotionCollection.find_by_code(params[:code]).items.create(params[:item])
    if params[:collection_item_type]=="GeneralResource"
      @resource = GeneralResource.new(params[:resource])
      @item.resource_id = @resource.id if @resource.save
    end
    @item.priority = 1 if @item.priority.blank?
    if @item.save
      flash[:notice] = '推广项添加成功!'
    else
      flash[:alert] = "推广项添加失败! #{@item.errors.full_messages}"
    end
    redirect_to admin_promotion_items_path(params[:code])
  end

  def update
    @item = PromotionItem.find(params[:id])
    @item.attributes = params[:item]
    if params[:collection_item_type]=="GeneralResource"
      @resource = GeneralResource.find(@item.resource_id)
      @resource.attributes = params[:resource]
      @resource.save
    end
    @item.priority = 1 if @item.priority.blank?
    if @item.save
      flash[:notice] = '推广项更新成功!'
    else
      flash[:alert] = "推广项更新失败! #{@item.errors.full_messages}"
    end
    redirect_to admin_promotion_items_path(params[:code]) + "?item_id=#{@item.id}"
  end

  def destroy
    @item = PromotionItem.find(params[:id])
    @item.destroy
    redirect_to admin_promotion_items_path(params[:code])
  end



end
