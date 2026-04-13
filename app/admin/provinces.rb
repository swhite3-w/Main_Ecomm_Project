ActiveAdmin.register Province do
  permit_params :name, :code, :gst_rate, :pst_rate, :hst_rate

  filter :name
  filter :code
  filter :gst_rate
  filter :pst_rate
  filter :hst_rate
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst_rate
    column :pst_rate
    column :hst_rate
    actions
  end
end