class Location < ActiveRecord::Base
  has_many :birthday_deals
  has_many :company_locations
  has_many :users
  has_many :birthday_parties

  geocoded_by :location_name, :latitude => :lat, :longitude => :lng
  after_validation :geocode, if: ->(location){location.city_changed? || location.state_changed? }

  def location_name
    %Q(#{city}, #{state})
  end
end
