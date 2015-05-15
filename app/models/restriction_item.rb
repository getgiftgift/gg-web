class RestrictionItem < ActiveRecord::Base
  belongs_to :restriction
  belongs_to :birthday_deal
end
