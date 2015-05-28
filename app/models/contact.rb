class Contact < ActiveRecord::Base
  belongs_to :company
  
  validates :first_name, :last_name, :email, presence: true  
  
end