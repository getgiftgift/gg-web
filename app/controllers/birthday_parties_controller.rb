class BirthdayPartiesController < ApplicationController
	

	def show
		@party = BirthdayParty.find params[:id]
		@user = @party.user
	end

end
