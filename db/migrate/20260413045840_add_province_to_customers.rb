class AddProvinceToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_reference :customers, :province, null: false, foreign_key: true
  end
end
