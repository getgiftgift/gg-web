desc "Send out todays birthday emails"
task :todays_birthday_emails => :environment do
  parties = BirthdayParty.birthday_is_today.is_funded 
  puts "Found #{parties.blank? ? 0 : parties.count} #{'party'.pluralize(parties.count)} to send"
  parties.each do |party|
    puts "sending..."
    Notifier.birthday_today(party)
  end
  puts "finished"
end


# desc "This task is used to keep Heroku awake"
# task :wakeup_heroku => :environment do
#    uri = URI.parse('http://birthdayclubjeffcity.herokuapp.com/')
#    Net::HTTP.get(uri)
# end

