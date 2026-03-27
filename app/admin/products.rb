ActiveAdmin.register Product do
  permit_params :title, :description, :price, :stock_quantity, :image_url, :is_featured, :is_active, :category_id

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