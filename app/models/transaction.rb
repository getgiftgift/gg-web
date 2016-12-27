class Transaction < ActiveRecord::Base
	belongs_to :birthday_party

  self.inheritance_column = :type
  BRAINTREE = 'braintree'

  monetize :amount_cents
end
