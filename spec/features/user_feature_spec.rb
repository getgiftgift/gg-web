require "rails_helper"

feature "User signs in" do
  scenario 'with valid credentials' do
    visit new_user_session_path
    fill_in 'user_email', with: 'david@addsheet.com'
    fill_in 'user_password', with: 'addsheet123'
    click_on 'Sign In'
    expect(page).to have_content('You have successfully signed in!')
  end



end