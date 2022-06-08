# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  code        :string(255)
#  description :string(255)
#  name        :string(255)
#  price       :decimal(10, 2)
#  stock       :integer
#  uuid        :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord

  before_save :notify_product_saving
  after_save :notify_product_saved
  before_update :notify_different_price, if: :price_is_changed?

  #Validations
  validates :name, presence: { message: 'Name has not been provided'}
  validates :description, presence: { message: 'Description has not been provided'}

  #Scopes
  scope :product_sum, -> { sum(:stock) }
  scope :cheaper_products, ->  (price) { where('price < ?', price) }
  scope :order_by_price, -> (type) { type != 'desc' ? order(price: :asc) : order(price: :desc) }

  #Class methods
  def self.top_five_products_by_price(type)
    self.select(:name, :price).order_by_price(type).limit(5)
  end

  def stock_changed?
    self.stock_was != self.stock && self.stock < 5
  end

  def out_of_stock
    if self.stock < 0
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

  def notify_different_price
    puts " - Price has changed - "
  end


  def price_is_changed?
    changes["price"] == nil ? false : true
  end

end

