class Dashboard::CompanyLocationsController < Dashboard::BaseController
  before_filter :get_company

  respond_to :html, :json

  # GET /companies
  # GET /companies.xml
  def index
    @company_locations = @company.company_locations.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @company_locations }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company_location = @company.company_locations.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company_location }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company_location = @company.company_locations.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company_location }
    end
  end

  # GET /companies/1/edit
  def edit
    @company_location = @company.company_locations.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js   {render :action => "edit"}
      format.xml  { render :xml => @contact }
    end
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company_location = @company.company_locations.new(location_params)

    respond_to do |format|
      if @company_location.save
        flash[:notice] = 'Company Location was successfully created.'
        format.html { redirect_to dashboard_company_path(@company) }
        format.xml  { render :xml => @company_location, :status => :created, :location => @company_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company_location = @company.company_locations.find(params[:id])
    respond_to do |format|
      if @company_location.update_attributes(location_params)
        flash[:notice] = 'Company location was successfully updated.'
        format.js   { render :js => 'window.location.reload()' }
        format.html { redirect_to dashboard_company_path(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company_location = @company.company_locations.find(params[:id])
    @company_location.destroy

    respond_to do |format|
      format.html { redirect_to(dashboard_companies_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def location_params
      params.require(:company_location).permit(:phone, :street1, :street2, :city, :state, :postal_code)
    end

    def get_company
      @company = Company.find(params[:company_id]) if params[:company_id]
    end
end
