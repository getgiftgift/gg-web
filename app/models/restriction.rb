class Restriction < ActiveRecord::Base
  has_many :birthday_deals, through: :restriction_items
  has_many :restriction_items

  scope :defaults, -> { where(category: 'default') }
end


