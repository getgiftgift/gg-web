class Sponsorship < ActiveRecord::Base
  has_many :transactions, class_name: 'SponsoredTransaction', foreign_key: "sponsorship_id"

  monetize :amount_per_party_cents
  monetize :total_amount_cents



  def amount_sponsored
    Money.new(transactions.sum(:amount_cents))
  end
end