require "rails_helper"

feature "User signs in" do
  scenario 'with valid credentials' do
    loc = Location.create(name: "Columbia, MO", city: "Columbia", state: 'MO')
    # build(:location)
    user = build(:user)
    login_as(user, :scope => :user, :run_callback => false)
    visit birthday_deals_path
    expect(page).to have_content("Select Your City")
    choose "user_location_1"
    click_button "Submit"
    expect(page).to have_content('Free presents? Tell me more!')

  end



end