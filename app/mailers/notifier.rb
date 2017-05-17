require 'mandrill'

class Notifier
  class << self
    def default_name
      "Gift Gift"
    end

    def default_from
      "no-reply@getgiftgift.com"
    end

    def mandrill_mail
      Mandrill::API.new
    end

    def welcome(user)
      subject = "Welcome to Gift Gift"
      template_name = "gift-gift-welcome"
      template_content = nil
      message = {
        "metadata"=>{"website"=>"www.getgiftgift.com"},
        "subaccount"=>"gift-gift",
        "merge"=>true,
        "global_merge_vars"=>[
          {"content"=>user.first_name, "name"=>"FNAME"},
          {"content"=> user.birthday, "name"=>"BDAY"}
        ],
        "to"=>
          [{"type"=>"to",
            "email"=> user.email,
            "name"=> user.full_name}
          ],
        "from_name"=> default_from,
        "subject"=> subject,
        "from_email"=> default_from,
        "important"=>true,
        "track_clicks"=>true,
        "track_opens"=>true,
      }

      result = mandrill_mail.messages.send_template template_name, template_content, message

    end

    def party_ready(party)
      subject = "It's Time to PARTY!"
      template_name = "gift-gift-party-ready"
      template_content = nil
      message = {
        "metadata"=>{"website"=>"www.getgiftgift.com"},
        "subaccount"=>"gift-gift",
        "merge"=>true,
        "global_merge_vars"=>[
          {"content"=> party.user.first_name, "name"=>"FNAME"},
          {"content"=> Rails.application.routes.url_helpers.birthday_party_url(party), "name"=>"URL"}
        ],
        "to"=>
          [{"type"=>"to",
            "email"=> party.user.email,
            "name"=> party.user.full_name}
          ],
        "from_name"=> default_from,
        "subject"=> subject,
        "from_email"=> default_from,
        "important"=>true,
        "track_clicks"=>true,
        "track_opens"=>true,
      }

      result = mandrill_mail.messages.send_template template_name, template_content, message
    end

    def chip_in(user, amount)  
      subject = "A friend chipped in to your party!"
      template_name = "gift-gift-chip-in"
      template_content = nil
      message = {
        "metadata"=>{"website"=>"www.getgiftgift.com"},
        "subaccount"=>"gift-gift",
        "merge"=>true,
        "global_merge_vars"=>[
          {"content"=> user.first_name, "name"=>"FNAME"},
          {"content"=> amount, "name"=>"AMOUNT"}
        ],
        "to"=>
          [{"type"=>"to",
            "email"=> user.email,
            "name"=> user.full_name}
          ],
        "from_name"=> default_from,
        "subject"=> subject,
        "from_email"=> default_from,
        "important"=>true,
        "track_clicks"=>true,
        "track_opens"=>true,
      }

      result = mandrill_mail.messages.send_template template_name, template_content, message
    end

    def chip_in_confirmation(user, amount)
      # user = party user
      subject = "A friend chipped in to your party!"
      template_name = "gift-gift-chip-in-confirm"
      template_content = nil
      message = {
        "metadata"=>{"website"=>"www.getgiftgift.com"},
        "subaccount"=>"gift-gift",
        "merge"=>true,
        "global_merge_vars"=>[
          {"content"=> user.first_name, "name"=>"FNAME"},
          {"content"=> amount, "name"=>"AMOUNT"}
        ],
        "to"=>
          [{"type"=>"to",
            "email"=> user.email,
            "name"=> user.full_name}
          ],
        "from_name"=> default_from,
        "subject"=> subject,
        "from_email"=> default_from,
        "important"=>true,
        "track_clicks"=>true,
        "track_opens"=>true,
      }

      result = mandrill_mail.messages.send_template template_name, template_content, message
    end
  end
end
