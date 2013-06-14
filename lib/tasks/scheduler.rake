desc "This task is used to keep Heroku awake"
task :wakeup_heroku => :environment do
   uri = URI.parse('http://birthdayclubjeffcity.herokuapp.com/')
   Net::HTTP.get(uri)
 end