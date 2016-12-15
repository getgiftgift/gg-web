class Transaction < ActiveRecord::Base
	belongs_to :birthday_party

  monetize :amount
end
