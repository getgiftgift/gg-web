class Notifier < MandrillMailer::TemplateMailer
  default from: 'no-reply@giftgift.me'

  def welcome(user)
    mandrill_mail(
      template: 'gift-gift-welcome',
      subject: 'Welcome to GiftGift',
      to: user.email,
      vars: {
        'FNAME' => user.first_name,
        'BDAY' => user.birthday
        },
      important: true
      ) 
  end

end
