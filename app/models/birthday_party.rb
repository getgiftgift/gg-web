class BirthdayParty < ActiveRecord::Base
  PARTY_VALID_FOR = 30.days
  PARTY_COST = Monetize.parse("$30.00")

  belongs_to :user

  has_many :transactions

  monetize :cost_cents

  before_create :set_party_cost


  def available?
    Time.now >= date && Time.now <= date + PARTY_VALID_FOR
  end

  def activated?
    Money.new(transactions.sum(:amount_cents)) == cost
  end

  private
  def set_party_cost
    self.cost = PARTY_COST
  end
end
