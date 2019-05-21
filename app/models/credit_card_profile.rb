class CreditCardProfile < ActiveRecord::Base
  belongs_to :user
  validates :expiry, presence: true

  def expired?
    return true if self.expiry.nil?
    mm, yy = self.expiry.slice(0,2), self.expiry.slice(2,4)
    expires_at = Date.parse("20#{yy}-#{mm}-01").beginning_of_month
    DateTime.now > expires_at
  end

end