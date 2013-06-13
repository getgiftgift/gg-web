class BirthdayDealsCompanyLocations < ActiveRecord::Base
  belongs_to :birthday_deal
  belongs_to :company_location
end
