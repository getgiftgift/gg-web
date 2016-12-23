class Transaction < ActiveRecord::Base
	belongs_to :birthday_party
  belongs_to :type, polymorphic: true

  monetize :amount_cents
end
