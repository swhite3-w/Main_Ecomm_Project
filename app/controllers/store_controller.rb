class StoreController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category).order(created_at: :desc)

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @products = @products.where("title LIKE ? OR description LIKE ?", keyword, keyword)
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:filter].present?
      case params[:filter]
      when "new"
       @products = @products.where("created_at >= ?", 3.days.ago)
      when "recent"
        @products = @products.where("updated_at >= ?", 3.days.ago)
                             .where("created_at < ?", 3.days.ago)
      when "on_sale"
       @products = @products.where("price < ?", 50) # simple version
      end
    end

    @products = @products.page(params[:page]).per(8)
  end

  def show
    @product = Product.find(params[:id])
  end

  def category
    @category = Category.find(params[:id])
    @categories = Category.order(:name)
    @products = @category.products.order(created_at: :desc).page(params[:page]).per(8)
  end

  def about
    @page = Page.find_by(slug: "about")
  end
end
