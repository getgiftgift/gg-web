class CompanyLocation < ActiveRecord::Base
  # include Geokit::Geocoders
  belongs_to :location
  belongs_to :company

  has_and_belongs_to_many :birthday_deals

  # before_save :geocode_address

  # attr_accessible :company_id, :company, :name, :phone, :fax, :street1, :street2, :city, :state, :postal_code, :location_id

  validates :phone, :street1, :city, :state, :postal_code, presence: true

  def inline_address
    address = ""
    address << self.name if self.name
    address << "#{self.street1} #{self.city},#{self.state} #{self.postal_code}"
    address
  end

  def geocode_address
    loc = Geokit::Geocoders::MultiGeocoder.geocode(self.map_address)
    #loc = Geokit::Geocoders::GoogleGeocoder.geocode(self.map_address)
    self.lat = loc.lat
    self.lng = loc.lng

  end

  def map_address
    "#{self.street1} #{self.street2} #{self.city},#{self.state} #{self.postal_code}"
  end

end