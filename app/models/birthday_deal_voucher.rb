class BirthdayDealVoucher < ActiveRecord::Base
  belongs_to :birthday_deal
  belongs_to :user
  has_one :company, through: :birthday_deal
  has_many :birthday_deal_voucher_state_transitions
  # attr_accessible :good_through, :valid_on, :user
  after_create :generate_verification_number

  # extend FriendlyId
  # friendly_id :verification_number

  delegate :hook, :value, to: :birthday_deal

  # attr_accessible :good_through, :valid_on, :user
  scope :is_available, lambda { where("valid_on <= ? and good_through >= ? ", Date.today.midnight.to_s(:db), Date.today.midnight.to_s(:db)) }
  scope :in_location, lambda { |location| joins(:birthday_deal).where("birthday_deals.location_id = ?", location.id) }

  state_machine initial: :wrapped do
    store_audit_trail

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
    generated_code = "#{id}#{((Time.now + id).to_i+user_id).to_s}"
    self.verification_number = generated_code
    save!
  end

  def plain_verification_number
    read_attribute(:verification_number)
  end
  
  def dashed_verification_number
    num = read_attribute(:verification_number).clone
    num.insert(id.to_s.length, '-')
    num.insert(num.length-5, '-')
    num
  end

end
