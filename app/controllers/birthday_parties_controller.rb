class BirthdayPartiesController < ApplicationController

  before_filter :create_token, only: [:index, :show]

  def index
		@party = current_user.birthday_party
    @user = current_user
    render :show
  end

  def show
    @party = BirthdayParty.where(id: params[:id]).includes(:transactions).first
		@user = @party.user
	end

  private

  def create_token
    @token = Braintree::ClientToken.generate
    @transaction = Transaction.new  
  end

end
