class Dashboard::LocationsController < Dashboard::BaseController

  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all.includes(:users, :birthday_deals)
    @users= User.all
    @recent_users = @users.where('created_at >= ?', Date.today-1.week)
    @vouchers = BirthdayDealVoucher.all
    @recent_vouchers = @vouchers.where('created_at >= ?', Date.today-1.week)
    respond_to do |format|
      format.html { }
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js   {render :action => "edit"}
    end
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(location_params)
    # @location.account_id = current_account.id

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(dashboard_locations_path) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(location_params)
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(dashboard_locations_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(dashboard_locations_url) }
      format.xml  { head :ok }
    end
  end
  private
  def location_params
    params.require(:location).permit(:name, :city, :state, :slug)
  end

end
