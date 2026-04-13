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

    def checkout
    session[:cart] ||= {}

    @cart_items = []
    @subtotal = 0

    session[:cart].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = quantity.to_i
      line_total = product.price * quantity

      @cart_items << {
        product: product,
        quantity: quantity,
        line_total: line_total
      }

      @subtotal += line_total
    end

    @provinces = Province.order(:name)
  end

  def place_order
    session[:cart] ||= {}

    if session[:cart].empty?
      flash[:alert] = "Your cart is empty."
      redirect_to cart_path
      return
    end

    province = Province.find(params[:province_id])

    customer = Customer.find_or_create_by!(email: params[:customer_email]) do |c|
      c.full_name = params[:customer_name]
      c.province = province
    end

    customer.update!(full_name: params[:customer_name], province: province)

    subtotal = 0
    cart_products = []

    session[:cart].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      quantity = quantity.to_i
      unit_price = product.price
      line_total = unit_price * quantity

      subtotal += line_total

      cart_products << {
        product: product,
        quantity: quantity,
        unit_price: unit_price,
        line_total: line_total
      }
    end

    gst_total = subtotal * province.gst_rate
    pst_total = subtotal * province.pst_rate
    hst_total = subtotal * province.hst_rate
    tax_total = gst_total + pst_total + hst_total
    grand_total = subtotal + tax_total

    order = Order.create!(
      customer: customer,
      status: "new",
      subtotal: subtotal,
      tax_total: tax_total,
      grand_total: grand_total,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate
    )

    cart_products.each do |item|
      OrderItem.create!(
        order: order,
        product: item[:product],
        quantity: item[:quantity],
        unit_price: item[:unit_price],
        line_total: item[:line_total]
     )
    end

    session[:cart] = {}
    flash[:notice] = "Order placed successfully."

    redirect_to order_confirmation_path(order)
  end

  def order_confirmation
    @order = Order.find(params[:id])
  end

end
