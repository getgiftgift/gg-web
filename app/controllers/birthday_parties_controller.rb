class BirthdayPartiesController < ApplicationController

  skip_filter   :verify_login_and_birthday, only: [:show]
  before_filter :create_token, only: [:index, :show]
  before_filter :set_party

  def index; end

  def show; end

  private

  def set_party
    if params[:id]
      @party = BirthdayParty.where(id: params[:id]).includes(:transactions).first
    else
      @party = current_user.birthday_party
    end

    return redirect_to root_url unless @party

    if @party.user == current_user
      @user = current_user
      render :index
    else
      @user = @party.user
      render :show
    end

  end

  def create_token
    @token = Braintree::ClientToken.generate
    @transaction = Transaction.new
  end

end
