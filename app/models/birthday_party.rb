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
    total_contributed == cost
  end

  def amount_complete_decimal
    total_contributed / cost
  end

  def amount_complete_percentage
    "#{(amount_complete_decimal * 100)}%"
  end

  def total_contributed
    @total_contributed ||= Money.new(transactions.sum(:amount_cents))
  end

  private
  def set_party_cost
    self.cost = PARTY_COST
  end
end
