ActiveAdmin.register Order do
  permit_params :customer_id, :status, :subtotal, :tax_total, :grand_total, :gst_rate, :pst_rate, :hst_rate

  filter :customer
  filter :status
  filter :subtotal
  filter :tax_total
  filter :grand_total
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column

    column("Customer Name") { |order| order.customer&.full_name }
    column("Customer Email") { |order| order.customer&.email }
    column("Province") do |order|
      if order.customer.respond_to?(:province) && order.customer.province.present?
        order.customer.province.code
      else
        order.customer&.province_code
      end
    end

    column("Item Count") do |order|
      order.order_items.sum(:quantity)
    end

    column("Products Ordered") do |order|
      order.order_items.map do |item|
        "#{item.product.title} x#{item.quantity}"
      end.join(" | ")
    end

    column :status
    column :subtotal
    column :tax_total
    column :grand_total
    column("GST %") { |order| "#{(order.gst_rate.to_f * 100).round(2)}%" }
    column("PST %") { |order| "#{(order.pst_rate.to_f * 100).round(2)}%" }
    column("HST %") { |order| "#{(order.hst_rate.to_f * 100).round(2)}%" }
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row("Customer Name") { |order| order.customer&.full_name }
      row("Customer Email") { |order| order.customer&.email }
      row("Province") do |order|
        if order.customer.respond_to?(:province) && order.customer.province.present?
          order.customer.province.name
        else
          order.customer&.province_code
        end
      end
      row :status
      row :subtotal
      row :tax_total
      row :grand_total
      row("GST Rate") { |order| "#{(order.gst_rate.to_f * 100).round(2)}%" }
      row("PST Rate") { |order| "#{(order.pst_rate.to_f * 100).round(2)}%" }
      row("HST Rate") { |order| "#{(order.hst_rate.to_f * 100).round(2)}%" }
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column("Product") { |item| item.product.title }
        column :quantity
        column("Unit Price") { |item| number_to_currency(item.unit_price) }
        column("Line Total") { |item| number_to_currency(item.line_total) }
      end
    end

    panel "Order Summary" do
      attributes_table_for order do
        row("Products Ordered") do |o|
          o.order_items.map { |item| "#{item.product.title} x#{item.quantity}" }.join(" | ")
        end
        row("Subtotal") { |o| number_to_currency(o.subtotal) }
        row("Tax Total") { |o| number_to_currency(o.tax_total) }
        row("Grand Total") { |o| number_to_currency(o.grand_total) }
      end
    end
  end
end