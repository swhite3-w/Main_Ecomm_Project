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
        @products = @products.where("price < ?", 50)
      end
    end

    @products = @products.page(params[:page]).per(14)
  end

  def show
    @product = Product.find(params[:id])
  end

  def category
    @category = Category.find(params[:id])
    @categories = Category.order(:name)
    @products = @category.products.order(created_at: :desc).page(params[:page]).per(14)
  end

  def about
    @page = Page.find_by(slug: "about")
  end

  def contact
    @page = Page.find_by(slug: "contact")
  end

  def cart
    session[:cart] ||= {}

    @cart_items = []
    @cart_total = 0

    session[:cart].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = quantity.to_i
      subtotal = product.price * quantity

      @cart_items << {
        product: product,
        quantity: quantity,
        subtotal: subtotal
      }

      @cart_total += subtotal
    end
  end

  def add_to_cart
    session[:cart] ||= {}

    product_id = params[:id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    product = Product.find(params[:id])
    flash[:notice] = "#{product.title} was added to your cart."

    redirect_to cart_path
  end

  def update_cart
    session[:cart] ||= {}

    product_id = params[:id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
      flash[:notice] = "Cart updated."
    else
      session[:cart].delete(product_id)
      flash[:notice] = "Item removed from cart."
    end

    redirect_to cart_path
  end

  def remove_from_cart
    session[:cart] ||= {}

    product_id = params[:id].to_s
    session[:cart].delete(product_id)

    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end
end
