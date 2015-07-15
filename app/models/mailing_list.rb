require 'httparty'

class MailingList 
  include HTTParty

  base_uri "http://us2.api.mailchimp.com/3.0"

  def self.subscribe(user)
    self.delay.subscribe_delayed(user)
  end

  def self.unsubscribe(user)
    self.delay.unsubscribe_delayed(user)
  end 

  def self.subscribe_delayed(user)
    response = post_subscribe(user)
    parsed_response = JSON.parse response.body
    if response.success?
      ## create a subscription if calling the MailingList.subscribe manually, since there probably 
      # won't be an existing subscription. 
      user.subscription.present? ? user.subscription.subscribe_confirmed! : Subscription.create(user: user, state: :subscribed)
    elsif parsed_response["staus"] == "500" # mailchimp internal server error
      ## try again later
      self.delay(run_at: 1.hour.from_now).subscribe(user)
    end
  end

  def self.unsubscribe_delayed(user)
    response = patch_unsubscribe(user)
    parsed_response = JSON.parse response.body
    if response.success?
      user.subscription.unsubscribe_confirmed!
    elsif parsed_response["staus"] == "500" # mailchimp internal server error
      ## try again later
      self.delay(run_at: 1.hour.from_now).unsubscribe(user)
    end
  end

  def self.post_subscribe(user)
    options = {
      email_address: user.email,
      status: "subscribed",
      merge_fields: {
        "FNAME": user.first_name,
        "LNAME": user.last_name,
        "BDAY": user.short_birthdate
      }
    }
    self.post("/lists/"+list_id+"/members/", headers: auth_header, body: options.to_json)
  end

  def self.patch_unsubscribe(user)
    options = {
      status: "unsubscribe"
    }
    self.patch("/lists/"+list_id+"/members/"+email_to_md5(user.email), headers: auth_header, body: options.to_json)
  end
  
  private
  def self.email_to_md5(email)
    Digest::MD5.hexdigest(email)
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