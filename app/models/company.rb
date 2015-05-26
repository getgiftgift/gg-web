class Company < ActiveRecord::Base
  has_many :birthday_deals
  has_many :company_locations
  has_many :contacts
  
  accepts_nested_attributes_for :contacts

  # attr_accessible :archived, :city, :image, :image_cache, :name, :phone, :postal_code, :state, :street1, :street2, :url

  mount_uploader :image, ImageUploader
end
