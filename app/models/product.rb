# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string(255)
#  name        :string(255)
#  price       :decimal(10, 2)
#  stock       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord

  before_save :notify_product_saving
  after_save :notify_product_saved
  before_update :out_of_stock, if: :stock_changed?

  def stock_changed?
    self.stock_was != self.stock && self.stock < 5
  end

  def out_of_stock
    if self.stock < 0 then
      puts " - Stock of #{self.name} can not be less than 0 - "
      throw(:abort)
    end
    puts " - Product #{self.name} with low stock, call provider - "
  end

  def notify_product_saving
    puts " - Product #{self.name} is being saved - "
  end

  def notify_product_saved
    puts " - Product #{self.name} saved - "
  end

end

