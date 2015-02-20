class Dashboard::BirthdayDealsController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_form_variables
  
  layout 'dashboard'

  # GET /birthday_deals
  # GET /birthday_deals.json
  def index
    # redirect(:back) if @location.nil?
    @location = Location.find(params[:location_id])
    @birthday_deals = BirthdayDeal.in_location(@location).without_state(:archived).order(:state).includes(:company)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @birthday_deals }
    end
  end

  # GET /birthday_deals/1
  # GET /birthday_deals/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @birthday_deal }
    end
  end

  # GET /birthday_deals/new
  # GET /birthday_deals/new.json
  def new
    @birthday_deal = @location.birthday_deals.new
    @birthday_deal.start_date = Date.today
    @birthday_deal.end_date = Date.today + 1.year
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @birthday_deal }
    end
  end

  # GET /birthday_deals/1/edit
  def edit
  end

  # POST /birthday_deals
  # POST /birthday_deals.json
  def create
    @birthday_deal = @location.birthday_deals.build(birthday_deal_params)

    respond_to do |format|
      if @birthday_deal.save
        format.html { redirect_to dashboard_location_birthday_deals_path(@location), notice: 'Birthday deal was successfully created.' }
        format.json { render json: @birthday_deal, status: :created, location: @birthday_deal }
      else
        format.html { render action: "new" }
        format.json { render json: @birthday_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @birthday_deal.approve if current_user.superadmin?
    respond_to do |format|
      format.html
      format.js { render 'approval_actions', layout: false}
    end
  end

  #approval process methods
  def submit_for_approval
    @birthday_deal.submit_for_approval
    respond_to do |format|
      format.html
      format.js { render 'approval_actions', layout: false}
    end
  end

  def withdraw
    @birthday_deal.withdraw
    respond_to do |format|
      format.html
      format.js { render 'approval_actions', layout: false}
    end
  end

  def approve
    if current_user.superadmin?
      @birthday_deal.approve!
    end
    respond_to do |format|
      format.html
      format.js { render 'approval_actions', layout: false}
    end
  end

  def reject
    if current_user.superadmin?
      @birthday_deal.reject
    end
    respond_to do |format|
      format.html
      format.js { render 'approval_actions', layout: false}
    end
  end

  # PUT /birthday_deals/1
  # PUT /birthday_deals/1.json
  def update

    respond_to do |format|
      if @birthday_deal.update_attributes(birthday_deal_params)
        @birthday_deal.edit
        format.html { redirect_to dashboard_location_birthday_deals_path(@birthday_deal.location), notice: 'Birthday deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @birthday_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birthday_deals/1
  # DELETE /birthday_deals/1.json
  def destroy
    @birthday_deal.destroy

    respond_to do |format|
      format.js { render 'approval_actions', layout: false }
      format.html { redirect_to dashboard_location_birthday_deals_path(@birthday_deal.location) }
      format.json { head :no_content }
    end
  end

  protected

  def set_form_variables
    @birthday_deal = (BirthdayDeal.find(params[:id]) if params[:id].present?)
    @location = @birthday_deal.try(:location) || (Location.find(params[:location_id]) if params[:location_id])
    @companies = Company.order('name asc')
    @company = @birthday_deal.try(:company)
    @model = 'birthday_deal'
  end

  private
  def birthday_deal_params
    params.require(:birthday_deal).permit(:hook, :how_to_redeem, :path, :restrictions, :company_id, :comany_location_id, :value, :start_date, :end_date, :state)
  end
end
 