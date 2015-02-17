class BirthdayDealStateTransition < ActiveRecord::Base
  belongs_to :birthday_deal
  # attr_accessible :birthday_deal_id, :created_at, :event, :from, :to
end
