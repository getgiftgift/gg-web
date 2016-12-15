class BirthdayPartiesController < ApplicationController

	def show
		@party = current_user.birthday_party
		@user = @party.user
	end

end
