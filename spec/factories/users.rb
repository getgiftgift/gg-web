FactoryGirl.define do

  factory :user do
    first_name  'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   '1980-04-20'
    password    'password'
  end

  trait :no_birthday do
    first_name   'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   ''
    password    'password'
  end

  trait :birthday_today do
    first_name   'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   Date.today
    password    'password'
  end

  trait :two_weeks_ago do
    first_name   'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   Date.today-2.weeks
    password    'password'
  end

  trait :two_weeks_ahead do
    first_name   'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   Date.today + 2.weeks
    password    'password'
  end

  trait :outside_15_days do
    first_name   'Ron'
    last_name   'Johnson'
    email       'ron@bigjohnson.com'
    birthdate   Date.today + 16.days
    password    'password'
  end

end