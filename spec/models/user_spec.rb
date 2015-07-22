require 'rails_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is valid without a birthdate' do
    expect(build(:user, :no_birthday)).to be_valid
  end

  it 'is eligible for birthday deals' do
    expect(build(:user, :birthday_today).eligible_for_birthday_deals?).to be true
  end

  it 'is eligible for birthday deals 2 weeks before birthday' do
    expect(build(:user, :two_weeks_ago).eligible_for_birthday_deals?).to be true
  end

  it 'is eligible for birthday deals 2 weeks after birthday' do
    expect(build(:user, :two_weeks_ahead).eligible_for_birthday_deals?).to be true
  end

  it 'is not eligible for birthday deals more than 15 days after birthday' do 
    expect(build(:user, :outside_15_days).eligible_for_birthday_deals?).to_not be true
  end

  it 'has a full_name' do
    user = build(:user)
    expect(user.full_name).to eq %Q(#{user.first_name} #{user.last_name})
  end

  it 'has a short_birthdate' do
    expect(build(:user).short_birthdate).to match /\d{,2}\/\d{,2}/ 
  end

end