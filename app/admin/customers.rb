ActiveAdmin.register Customer do
  permit_params :email, :full_name, :province_id

  # Only show safe filters
  filter :email
  filter :full_name
  filter :province
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :full_name
    column :province
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :full_name
      row :province
      row :created_at
      row :updated_at
    end
  end
end