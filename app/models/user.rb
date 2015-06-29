class User < ActiveRecord::Base
  include ApplicationHelper
  after_create :build_referral_code

  has_one :subscription
  belongs_to :location
  has_many :birthday_deal_vouchers
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
    
    where(provider: auth['provider'], uid: auth['uid']).first_or_initialize.tap do |user|
      user.password = Devise.friendly_token[0,20]
      user.uid = auth['uid']
      user.email = auth['email']            # required by Facebook
      user.first_name = auth['first_name']  # required by Facebook
      user.last_name = auth['last_name']    # required by Facebook
      user.birthdate = Date.strptime( auth['birthday'], "%m/%d/%Y" )  # required by Facebook
      user.gender = auth['gender']  # required by Facebook 
      user.oauth_token = auth['access_token']
      user.oauth_expires_at = Time.at(Time.now + auth['expires'].to_i)
      user.location = Location.first
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

  def build_referral_code
    # 5 character referral code
    # avoids similar characters like l and 1, o and 0 etc. 
    charset = %w{ 2 3 4 6 7 9 a c d e f g h j k m n p q r t v w x y z}
    code = (0...5).map{ charset.to_a[SecureRandom.random_number(charset.size)] }.join
    update_attributes referral_code: code
    self.build_subscription
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_birthdate
    self.birthdate.strftime('%m/%d')
  end

  def birthday
    bday = self.test_user? ? Date.today : self.birthdate
    bday.strftime('%B %d')
  end

  def birthdate=(birthdate)
    write_attribute(:birthdate, birthdate)
  end

  def adjusted_birthday
    birthdate = self.test_user? ? Date.today : self.birthdate
    return nil if birthdate.nil?
    birthday_string = birthdate.strftime('%m%d')
    today = Date.today.strftime('%m%d')
    start_date = (birthdate - 15.days).strftime('%m%d')
    end_date = (birthdate + 15.days).strftime('%m%d')
    if end_date < start_date # The birthday club range crosses years
      if birthday_string >= '0101' && birthday_string <= end_date # The birthday is in the new year
        if today <= '1231' && today >= (Date.today - 1.month).strftime('%m%d') # Today is in the earlier year
          birthday = birthdate.change(year: (Date.today + 1.year).year) # The birthday occurs in the next year
        elsif today >= '0101'# Today is in the new year
          birthday = birthdate.change(year: (Date.today.year)) # This birthday is in the current year
        end
      elsif birthday_string <= '1231' && birthday_string >= start_date # The birthday is in the earlier year
        if today <= '1231' && today >= start_date # Today is in the earlier year
          birthday = birthdate.change(year: (Date.today.year)) # The birthday occurs in this year
        elsif today >= '0101' && today <= end_date # Today is in the new year
          birthday = birthdate.change(year: (Date.today - 1.year).year) # This birthday is in the previous year
        end
      end
    else
      birthday = birthdate.change(year: Date.today.year) unless birthdate.month == 2 && birthdate.day == 29 && !Date.today.leap?
    end
    if birthdate.leap? && birthdate.month == 2 && birthdate.day == 29 && !Date.today.leap?  # Customer has a leap year birthday and on leap day and its not a leap year
      birthday = birthdate.change(day: 28, year: Date.today.year)
    end
    birthday
  end

  def eligible_for_birthday_deals?
    return true if self.test_user?
    date_start = (Date.today - 15.days).strftime('%m%d')
    date_end = (Date.today + 15.days).strftime('%m%d')
    user_bday = self.birthdate.strftime('%m%d')
    if date_end < date_start # Birthday overlaps new year 
      if (user_bday >= "0101" and user_bday <= end_date) or ( user_bday <= "1231" and user_bday >= start_date )
        return true
      else
        return false  
      end  
    else
      return true if user_bday <= date_end and user_bday >= date_start
    end
  end

  def test_user?
    self.email == 'birthday@giftgift.me'
  end

  def change_password(password)
    self.update_attributes(password: password, password_confirmation: password)
  end

  def reset_birthday_deals()
    self.birthday_deal_vouchers.each do |voucher|
      voucher.reset! if voucher.valid_on.year == Time.now.year || voucher.good_through.year == Time.now.year
    end
  end

  def build_subscription
    self.subscription = Subscription.create
    self.subscription.subscribe!
  end


end
