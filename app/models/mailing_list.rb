class MailingList 
  def self.subscribe(user)
    self.delay.subscribe_delayed(user)
  end

  def self.update_subscription(user)
    self.delay.update_subscription_delayed(user)
  end 

  private
  def self.subscribe_delayed(user)
    api = new_api
    api.listSubscribe(:id => MC_LIST_ID, 
                      :email_address => user.email, 
                      :merge_vars => get_merge_vars(user), 
                      :email_type => 'html', 
                      :double_optin => false, 
                      :update_existing => true, 
                      :replace_interests => false, 
                      :send_welcome => false )
  end

  def self.update_subscription_delayed(user)
    api = new_api
    response = api.listMemberInfo(:id => MC_LIST_ID, :email_address => user.email)

    if response['data'][0]['error'] == "The email address passed does not exist on this list"
      self.subscribe(user)  
    else  
      api.listUpdateMember( :id => MC_LIST_ID, 
                            :email_address => user.email, 
                            :merge_vars => get_merge_vars(user), 
                            :email_type => 'html',  
                            :replace_interests => false, )
    end  
  end

  def self.get_merge_vars(user)
    return { 'FNAME' => user.first_name, 'LNAME' => user.last_name, 'BDAY' => user.short_birthdate } 
  end

  def self.new_api
    return Mailchimp::API.new(MC_APIKEY)
  end

end

