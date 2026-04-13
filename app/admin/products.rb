ActiveAdmin.register Product do
  permit_params :title, :description, :price, :stock_quantity, :image_url, :is_featured, :is_active, :category_id

  filter :title
  filter :description
  filter :price
  filter :stock_quantity
  filter :is_featured
  filter :is_active
  filter :category
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :stock_quantity
    column :category
    column :is_featured
    column :is_active
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :image_url
      f.input :is_featured
      f.input :is_active
      f.input :category
    end
    f.actions
  end
end