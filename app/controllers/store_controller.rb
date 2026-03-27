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
      when "featured"
        @products = @products.where(is_featured: true)
      when "active"
        @products = @products.where(is_active: true)
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
