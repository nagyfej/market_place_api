class Product < ActiveRecord::Base
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true

   belongs_to :user

   scope :filter_by_title, lambda { | keyword | where("lower(title) LIKE ?", "%#{keyword.downcase}%" ) }
   scope :above_or_equal_to_price, lambda { | price | where('price >= ?', price) }
   scope :below_or_equal_to_price, lambda { | price | where('price <= ?', price) }
   scope :recent, lambda { order(:updated_at) }

   def self.search(search_hash = {})
     list = search_hash[:product_ids].present? ? Product.find(search_hash[:product_ids]) : Product.all
     list = list.filter_by_title(search_hash[:keyword]) if search_hash[:keyword]
     list = list.above_or_equal_to_price(search_hash[:min_price]) if search_hash[:min_price]
     list = list.below_or_equal_to_price(search_hash[:max_price]) if search_hash[:max_price]
     list = list.recent if search_hash[:recent]
     list
   end

end
