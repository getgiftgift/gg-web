class Referral < ActiveRecord::Base
  belongs_to :referrer,   :class_name => "User"
  belongs_to :recipient,  :class_name => "User"

  # referrer, recipient, activated

end