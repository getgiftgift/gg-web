class User < ActiveRecord::Base
  rolify
  include ApplicationHelper
  after_create :build_referral_code

	has_many :birthday_parties

  has_one :subscription
  accepts_nested_attributes_for :subscription
  belongs_to :location

  has_many :birthday_deal_vouchers, -> {merge(BirthdayParty.redeemable)}, through: :birthday_parties

  has_many :referrals_received, :foreign_key => :recipient_id,
                                :class_name => "Referral"
  has_many :referrals_made, :foreign_key => :referrer_id,
                                :class_name => "Referral"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook]

  validates :email, :uniqueness => { :case_sensitive => false, :message => 'The email you entered is associated with another account'},
                    :length => { :within => 3..100, :message => 'Invalid Length' },
                    :presence => {:message => "Required Field"}
  validates_length_of       :email,    :within => 3..100, :allow_nil => true, :allow_blank => true

  validates_presence_of     :email, :message => "Required Field"

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['id']).first_or_initialize.tap do |user|
      user.password = Devise.friendly_token[0,20]
      user.email = auth['email']            # required by Facebook
      user.first_name = auth['first_name']  # required by Facebook
      user.last_name = auth['last_name']    # required by Facebook
      user.birthdate = Date.strptime( auth['birthday'], "%m/%d/%Y" )  # required by Facebook
      user.gender = auth['gender']  # required by Facebook
      user.oauth_token = auth['access_token']
      user.oauth_expires_at = Time.at(Time.now + auth['expires'].to_i)
      # user.location = Location.near(auth['location']['name'], 50).first  # "City, State"
      user.save!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def birthday_party
    # either currently active or next future birthday. Should there be a period to review the previous party?
    @birthday_party ||= birthday_parties.redeemable.first || birthday_parties.includes(:transactions).where(start_date: next_birthday).first_or_create
  end

  def build_referral_code
    # 5 character referral code
    # avoids similar characters like l and 1, o and 0 etc.
    charset = %w{ 2 3 4 6 7 9 a c d e f g h j k m n p q r t v w x y z}
    code = (0...5).map{ charset.to_a[SecureRandom.random_number(charset.size)] }.join
    update_attributes referral_code: code
    self.build_subscription
  end

  def days_til_next_birthday
    (next_birthday.to_time.to_i - Date.today.to_time.to_i) / 1.day
  end

  def full_name
    %Q(#{first_name} #{last_name})
  end

  def possessive_full_name
    full_name + ('s' == full_name[-1,1] ? "'" : "'s")
  end

  def possessive_first_name
    full_name + ('s' == full_name[-1,1] ? "'" : "'s")
  end

  def short_birthdate
    self.birthdate.strftime('%m/%d')
  end

  def birthday
    bday = self.is_testuser? ? Date.today : self.birthdate
    bday.strftime('%B %d')
  end

  def birthdate=(birthdate)
    write_attribute(:birthdate, birthdate)
  end

  def next_birthday
    return nil unless birthdate
    if adjusted_birthday < Date.today
      adjusted_birthday + 1.year
    else
      adjusted_birthday
    end
  end

  def adjusted_birthday
    return nil unless birthdate
    birthdate + (Date.today.year - birthdate.year).years
  end

  def eligible_for_birthday_deals?
    birthday_party.available?
  end

  def change_password(password)
    self.update_attributes(password: password, password_confirmation: password)
  end

  # def reset_birthday_deals()
  #   self.birthday_deal_vouchers.each do |voucher|
  #     voucher.reset! if voucher.valid_on.year == Time.now.year || voucher.good_through.year == Time.now.year
  #   end
  # end

  def build_subscription
    self.subscription = Subscription.create
    self.subscription.subscribe!
  end

  def save_referral_code(referral_code)
    referrer = User.where(referral_code: referral_code).first
    Referral.create(recipient: self, referrer: referrer) if referrer && referrer != self
  end

  def subscription_options
    {
      email_address: email,
      merge_fields: {
        "FNAME": first_name,
        "LNAME": last_name,
        "BDAY": short_birthdate
      }
    }
  end

  def has_presents_to_open?
    eligible_for_birthday_deals? && birthday_deal_vouchers.with_state(:wrapped).count > 0 ? true : false
  end

end
