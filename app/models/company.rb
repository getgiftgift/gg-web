class Company < ActiveRecord::Base
  has_many :birthday_deals
  has_many :company_locations
  has_many :contacts
  
  accepts_nested_attributes_for :contacts

  # attr_accessible :archived, :city, :image, :image_cache, :name, :phone, :postal_code, :state, :street1, :street2, :url
  validates :name, presence: true

  mount_uploader :image, ImageUploader

  def map_address
    "#{self.street1} #{self.street2} #{self.city},#{self.state} #{self.postal_code}"
  end
end
