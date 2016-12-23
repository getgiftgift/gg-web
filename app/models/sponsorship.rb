class Sponsorship < ActiveRecord::Base
  has_many :transactions, as: :type
end