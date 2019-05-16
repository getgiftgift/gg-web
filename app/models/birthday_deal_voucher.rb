class BirthdayDealVoucher < ActiveRecord::Base
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/html_outputter'
  include HasBarcode

  has_barcode :barcode,
    :outputter => :svg,
    :type => :code_128,
    :value => Proc.new { |c| c.verification_number }

  belongs_to :birthday_deal
  belongs_to :birthday_party
  has_one :user, through: :birthday_party
  has_one :company, through: :birthday_deal
  has_one :payment_transaction, class_name: 'Transaction', foreign_key: 'voucher_id'
  has_many :birthday_deal_voucher_state_transitions, dependent: :destroy

  after_create :generate_verification_number
  delegate :hook, :value, to: :birthday_deal

  scope :is_available, -> { where("valid_on <= ? and good_through >= ? ", Date.today.midnight.to_s(:db), Date.today.midnight.to_s(:db)) }
  scope :in_location, -> location { joins(:birthday_deal).where("birthday_deals.location_id = ?", location.id) }

  state_machine initial: :wrapped do
    audit_trail

    ### Events ###
    event :unwrap do
      transition :inital => :open
    end

    event :keep do
      transition all => :kept
    end

    event :trash do
      transition all => :trashed
    end

    event :print_voucher do
      transition all - [:redeemed, :printed] => :printed
    end

    event :redeem do
      transition all - [:redeemed] => :redeemed
    end

    event :reset do
      transition all => :wrapped
    end

    ### States ###

    state :unwrapped do
      wrapped = false
    end

    state :kept do
      def active?
        true
      end

      def status
        "Available"
      end
    end

    state :trashed do
      def active?
        false
      end

    end

    state :redeemed do
      def active?
        false
      end
      def status
        "Printed/Used"
      end
    end

    state :printed do
      def active?
        false
      end
      def status
        "Printed/Used"
      end
    end
  end

  def redeemed_on
    self.birthday_deal_voucher_state_transitions.where(event: 'redeem').last.try(:created_at) || nil
  end

  def generate_verification_number
    generated_code = "#{id}#{((Time.now + id).to_i+birthday_party.user.id).to_s}"
    update_attributes verification_number: generated_code
  end

  def dashed_verification_number
    num = verification_number.clone
    num.insert(4, '-').insert(8, '-')
  end

  def make_redeemable!
    update redeemable: true
  end

  # def barcode
  #   barcode = Barby::Code128B.new(self.verification_number)
  #   output = Barby::HtmlOutputter.new(barcode)
  #   output.to_html
  # end

end
