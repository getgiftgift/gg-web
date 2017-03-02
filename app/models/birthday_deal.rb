class BirthdayDeal < ActiveRecord::Base
  belongs_to :company
  belongs_to :location
  belongs_to :occasion
  has_many :restriction_items
  has_many :restrictions, through: :restriction_items
  has_many :birthday_deal_vouchers, dependent: :destroy
  has_and_belongs_to_many :company_locations
  has_many :transition_records, foreign_key: 'birthday_deal_id', class_name: "BirthdayDealStateTransition"

  monetize :value_cents

  scope :in_location, -> location {  where("birthday_deals.location_id = ?", location.id) }
  scope :is_active, -> { where("start_date <= ? and end_date >= ? ", Date.today.midnight.to_s(:db), Date.today.midnight.to_s(:db)).with_state(:approved) }

  state_machine initial: :unapproved do
    audit_trail

    event :submit_for_approval do
      transition :unapproved => :pending_approval
    end

    event :edit do
      transition all - :archived => :unapproved
    end

    event :approve do
      transition all => :approved
    end

    event :archive do
      transition all => :archived
    end

    event :withdraw do
      transition all => :unapproved
    end

    event :reject do
      transition all => :unapproved
    end

    state :unapproved do
      def active?
        false
      end
    end

    state :pending_approval do
      def active?
        false
      end
    end

    state :approved do
      def active?
        if start_date <= Date.today && Date.today <= end_date
          true
        else
          false
        end
      end
    end

    state :archived do
      def active?
        false
      end
      # def update
      #   false
      # end
    end

  end

  def destroy
    self.archive
  end

  def delete
    self.destroy
  end

  def create_voucher_for(birthday_party)
    voucher = self.birthday_deal_vouchers.create(birthday_party: birthday_party, valid_on: birthday_party.start_date, good_through: birthday_party.end_date)
    if birthday_party.user.is_testuser?
      voucher.verification_number = "#{voucher.id}000000000"
      voucher.save
    end
  end

  def show_restrictions
    string = ""
    self.restrictions.each{|r| string << "#{r.phrase} "}
    string
  end
end