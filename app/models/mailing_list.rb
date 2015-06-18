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
    json_response = JSON.parse(response)
    if json_response['status'] == '200'
      user.subscription.subscribe_confirmed!
    end

    # unless JSON.parse(response)['status'] == '200'
    #   self.update_subscription(user)
    # end
  end

  def self.update_subscription(user)
    

  end

private
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