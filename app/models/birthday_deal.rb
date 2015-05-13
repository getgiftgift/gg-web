class BirthdayDeal < ActiveRecord::Base
  belongs_to :company
  belongs_to :location
  has_many :birthday_deal_vouchers
  has_and_belongs_to_many :company_locations
  has_many :transition_records, foreign_key: 'birthday_deal_id', class_name: "BirthdayDealStateTransition"

  # attr_accessible :hook, :how_to_redeem, :path, :restrictions, :company_id, :company_location_ids, :value, :start_date, :end_date

  scope :in_location, -> location {  where("location_id = ?", location.id) }
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

  def create_voucher_for(user)
    voucher = self.birthday_deal_vouchers.create(user: user, valid_on: user.adjusted_birthday - 15.days, good_through: user.adjusted_birthday + 15.days)
    if user.test_user?
      voucher.verification_number = "#{voucher.id}000000000"
      voucher.save
    end
  end
end