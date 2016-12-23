class BirthdayParty < ActiveRecord::Base
  PARTY_VALID_FOR = 30.days

  belongs_to :user

  has_many :transactions

  def available?
    Time.now >= date && Time.now <= date + PARTY_VALID_FOR
  end
end
