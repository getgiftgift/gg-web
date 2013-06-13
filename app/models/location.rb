class Location < ActiveRecord::Base
  has_many :birthday_deals
  has_many :company_locations


  attr_accessible :city, :lat, :lng, :name, :slug, :state
end
