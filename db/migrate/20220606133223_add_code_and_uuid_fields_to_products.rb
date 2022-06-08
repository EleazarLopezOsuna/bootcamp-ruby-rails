class AddCodeAndUuidFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :code, :string
    add_column :products, :uuid, :text
  end
end
