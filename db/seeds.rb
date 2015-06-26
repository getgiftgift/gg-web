# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Location.first_or_create(name: 'Columbia', city: 'Columbia', state: 'MO')
%w[
  david@addsheet.com
  joshuasmith.ca@gmail.com
].each do |email|
  user = User.where(email: email).first_or_create(
    admin: true
  )
  user.change_password('password')
end
