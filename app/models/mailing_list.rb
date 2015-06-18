require 'httparty'

class MailingList 
  include HTTParty

  base_uri "http://us2.api.mailchimp.com/3.0"

  def self.subscribe(user)
    self.delay.subscribe_delayed(user)
  end

  def self.update_subscription(user)
    self.delay.update_subscription_delayed(user)
  end 

  private
  def self.subscribe_delayed(user)
    options = {
      email_address: user.email,
      status: "subscribed",
      merge_fields: {
        "FNAME": user.first_name,
        "LNAME": user.last_name,
        "BDAY": user.short_birthdate
      }
    }
    response = self.post("/lists/"+list_id+"/members/", headers: auth_header, body: options.to_json)
    json_response = JSON.parse response.body
    if json_response['status'] == 'subscribed'
      
      ## create a subscription if calling the MailingList.subscribe manually, since there probably 
      # won't be an existing subscription.
      # 
      user.subscription.present? ? user.subscription.subscribe_confirmed! : Subscription.create(user: user, state: :subscribed)
    end
  end

  def self.update_subscription(user)
    ## Existing member response.
    # "status"=>400, "detail"=>"email@gmail.com is already a list member.  Use PATCH to update existing members."

  end

  def self.auth_header
    {"Authorization"=>"apikey #{ENV['MAILCHIMP_API_KEY']}"}
  end

  def self.list_id
    ENV['MAILCHIMP_LIST_ID']
  end

  def self.new_api
    Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
  end

end 