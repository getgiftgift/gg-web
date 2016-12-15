class BirthdayPartiesController < ApplicationController

  def index
		@party = current_user.birthday_party
    @user = current_user
  end

  def show
    @party = BirthdayParty.find(params[:id])
		@user = @party.user
	end

end
