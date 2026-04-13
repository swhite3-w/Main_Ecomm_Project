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
    column("Customer Name") { |order| order.customer.full_name }
    column("Customer Email") { |order| order.customer.email }
    column :status
    column :subtotal
    column :tax_total
    column :grand_total
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row("Customer Name") { |order| order.customer.full_name }
      row("Customer Email") { |order| order.customer.email }
      row :status
      row :subtotal
      row :tax_total
      row :grand_total
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :unit_price
        column :line_total
      end
    end
  end
end