class User < ActiveRecord::Base
  has_many :birthday_deal_vouchers

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of     :first_name, :last_name, :message => "Required Field"
  validates_presence_of     :password,:message => "Required Field",                   :if => :password_required?
  validates_presence_of     :password_confirmation, :message => "Required Field",     :if => :password_required?
  validates_length_of       :password, :within => 4..40, :message => 'Is Too Short (Minimum Is 4 Characters)',  :if => :password_required?
  validates_confirmation_of :password, :message => "Does Not Match Confirmation"
  validates :email, :uniqueness => { :case_sensitive => false, :message => 'The email you entered is associated with another account'},
                    :length => { :within => 3..100, :message => 'Invalid Length' },
                    :presence => {:message => "Required Field"}
  validates_length_of       :email,    :within => 3..100, :allow_nil => true, :allow_blank => true

  validates_presence_of     :email, :message => "Required Field"
  # validates_presence_of     :birthdate, :message => "Required Field"
  validates_presence_of :birthdate

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :encrypted_password, :birthdate
  # attr_accessible :title, :body

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
    # birthdate = self.birthdate
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
    date_start = (Date.today - 15.days)
    date_end = (Date.today + 15.days)
    return true
    if date_end.strftime('%m%d') < date_start.strftime('%m%d') # Birthday overlaps new year 
    ### MYSQL
    #   where_sql = "(DATE_FORMAT(`birthdate`, '%m%d') >= \"0101\""
    #   where_sql << " AND DATE_FORMAT(`birthdate`, '%m%d') <= \"#{date_end.strftime('%m%d')}\")"
    #   where_sql << " OR (DATE_FORMAT(`birthdate`, '%m%d') >= \"#{date_start.strftime('%m%d')}\""
    #   where_sql << " AND DATE_FORMAT(`birthdate`, '%m%d') <= \"1231\")"
    #
    # else
    #   where_sql = "DATE_FORMAT(`birthdate`, '%m%d') >= \"#{date_start.strftime('%m%d')}\" AND DATE_FORMAT(`birthdate`, '%m%d') <= \"#{date_end.strftime('%m%d')}\""
    # end
    ###
    ## PSQL
      where_sql = "(to_char(birthdate, 'MMDD') >= \"0101\""
      where_sql << " AND to_char(birthdate, 'MMDD') <= \"#{date_end.strftime('%m%d')}\")"
      where_sql << " OR (to_char(birthdate, 'MMDD') >= \"#{date_start.strftime('%m%d')}\""
      where_sql << " AND to_char(birthdate, 'MMDD') <= \"1231\")"  
    else
      where_sql = "DATE_FORMAT(`birthdate`, '%m%d') >= \"#{date_start.strftime('%m%d')}\" AND DATE_FORMAT(`birthdate`, '%m%d') <= \"#{date_end.strftime('%m%d')}\""
    end
    User.where(id: self.id).where(where_sql).count > 0 ? true : false
  end

  def test_user?
    self.email == 'birthday@addsheet.com'
  end
end
