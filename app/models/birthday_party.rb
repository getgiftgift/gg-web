class BirthdayParty < ActiveRecord::Base
  PARTY_VALID_FOR = 30.days
  PARTY_COST = Monetize.parse("$30.00")
  MINIMUM_DONATION = Money.new(300)

  belongs_to :user
  belongs_to :location

  has_many :transactions

  has_many :sponsored_transactions

  has_many :sponsorships, through: :sponsored_transactions, foreign_key: :sponsorship_id

  has_many :birthday_deal_vouchers, dependent: :destroy

  monetize :cost_cents

  before_create :set_party_attributes
  after_create :create_vouchers

  scope :redeemable, -> { where("? BETWEEN start_date and end_date", Time.zone.now)}
  scope :available_to_sponsor, -> { where("end_date >= ?", Time.zone.now)}
  scope :birthday_is_today, -> {where("start_date = ?", Time.zone.today)}
  scope :is_funded, -> {joins(:transactions).having("birthday_parties.cost_cents = SUM(transactions.amount_cents)").group(:id)}

  def available?
    Time.zone.now >= start_date && Time.zone.now <= end_date
  end

  def activated?
    total_contributed == cost
  end

  def amount_complete_decimal
    total_contributed / cost
  end

  def amount_complete_percentage
    #adds one for the progress meter styling
    return "0%" unless amount_complete_decimal > 0
    "#{(amount_complete_decimal * 100) + 1}%"
  end

  def days_since_first_transaction
    return 0 if transactions.blank?
    (Time.zone.now - transactions.order(created_at: :asc).first.created_at).to_i / 1.day
  end

  def minimum_donation
    [total_remaining, MINIMUM_DONATION].min
  end

  def total_contributed
    @total_contributed ||= Money.new(transactions.sum(:amount_cents))
  end

  def total_remaining
    cost - total_contributed
  end

  def create_vouchers
    reload
    BirthdayDeal.is_active.in_location(location).each do |deal|
      birthday_deal_vouchers.create(birthday_deal: deal, valid_on: start_date, good_through: end_date)
    end
  end

  private
  def set_party_attributes
    self.cost = PARTY_COST
    self.end_date = start_date + PARTY_VALID_FOR
    self.location = user.location
  end

end