require 'httparty'

# Add/remove user emails to mailchimp list via api 3.0
class MailingList
  include HTTParty

  base_uri 'http://us2.api.mailchimp.com/3.0'

  class << self
    def subscribe(user)
      add_to_list(user)
    end

    def unsubscribe(user)
      remove_from_list(user)
    end

    def add_to_list(user)
      list_status = get_status(user.email)
      if !list_status.success? ## adding brand new user, not success (404) means not on list yet
        response = post_subscribe(user)
        parsed_response = JSON.parse response.body
        if response.success?
          ## create a subscription if calling the
          # MailingList.subscribe manually, since 
          # there probably won't be an existing subscription. 
          user.subscription.present? ? user.subscription.subscribe_confirmed! : Subscription.create(user: user, state: :subscribed)
        elsif parsed_response['staus'] == '500' 
          ## mailchimp internal server error
          ## try again later
          # delay(run_at: 1.hour.from_now).subscribe(user)
        end
      else ## updating status of user on list but not subscribed
        update_status(user, 'subscribed')
        user.subscription.subscribe_confirmed!
      end
    end

    def remove_from_list(user)
      response = patch_unsubscribe(user.email)
      parsed_response = JSON.parse response.body
      if response.success?
        user.subscription.unsubscribe_confirmed!
      elsif parsed_response['status'] == '500' # mailchimp internal server error
        ## try again later
        # delay(run_at: 1.hour.from_now).unsubscribe(user)
      end
    end

    def post_subscribe(user)
      options = user.subscription_options
      options[:status] = 'subscribed'
      post(lists_members, 
           headers: auth_header, 
           body: options.to_json)
    end

    def patch_unsubscribe(email)
      options = { status: 'unsubscribed' }
      patch(lists_members_email(email),
            headers: auth_header,
            body: options.to_json)
    end

    def get_status(email)
      get(lists_members_email(email), headers: auth_header)
    end

    def subscription_status(user)
      response = get_status(user.email)
      parsed_response = JSON.parse response.body
      parsed_response['status']
    end

    def update_status(user, status)
      options = user.subscription_options
      options[:status] = status
      patch(lists_members_email(user.email), headers: auth_header, body: options.to_json)
    end

    private

    def lists_members_email(email)
      "/lists/#{list_id}/members/#{email_to_md5(email)}"
    end

    def lists_members
      "/lists/#{list_id}/members/"
    end

    def email_to_md5(email)
      Digest::MD5.hexdigest(email)
    end

    def auth_header
      { 'Authorization' => "apikey #{ENV['MAILCHIMP_API_KEY']}" }
    end

    def list_id
      ENV['MAILCHIMP_LIST_ID']
    end

    def new_api
      Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    end
  end
end 