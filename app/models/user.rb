class User < ActiveRecord::Base
  include ApplicationHelper
  after_create :build_referral_code

  has_many :birthday_deal_vouchers
  has_many :referrals_received, :foreign_key => :recipient_id,
                                :class_name => "Referral"

  has_many :referrals_made, :foreign_key => :referrer_id,
                                :class_name => "Referral"
  

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  devise :omniauthable, omniauth_providers: [:facebook]



  # validates_presence_of     :first_name, :last_name, :message => "Required Field"
  # validates_presence_of     :password,:message => "Required Field",                   :if => :password_required?
  # validates_presence_of     :password_confirmation, :message => "Required Field",     :if => :password_required?
  # validates_length_of       :password, :within => 4..40, :message => 'Is Too Short (Minimum Is 4 Characters)',  :if => :password_required?
  # validates_confirmation_of :password, :message => "Does Not Match Confirmation"
  validates :email, :uniqueness => { :case_sensitive => false, :message => 'The email you entered is associated with another account'},
                    :length => { :within => 3..100, :message => 'Invalid Length' },
                    :presence => {:message => "Required Field"}
  validates_length_of       :email,    :within => 3..100, :allow_nil => true, :allow_blank => true

  validates_presence_of     :email, :message => "Required Field"
  # validates_presence_of     :birthdate, :message => "Required Field"
  # validates_presence_of :birthdate

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :encrypted_password, :birthdate
  
  # attr_accessible :title, :body


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email                                                  # required by Facebook
      user.first_name = auth.info.first_name                                        # required by Facebook
      user.last_name = auth.info.last_name                                          # required by Facebook
      user.birthdate = Date.strptime( auth.extra.raw_info.birthday, "%m/%d/%Y" )    # required by Facebook
      user.gender = auth.extra.raw_info.gender                                      # required by Facebook 
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      # user.image = auth.info.image
      # user.location = auth.info.location  # "City, State"
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
    birthdate = Date.today  ## Development testing in production env
    # Rails.env.production? ? birthdate = self.birthdate : birthdate = Date.today  ## Production
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
    return true  ## Development testing in production env
    # return true if self.test_user?
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
    self.email == 'birthday@addsheet.com'
  end
end
