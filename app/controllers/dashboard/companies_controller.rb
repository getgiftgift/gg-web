class Dashboard::CompaniesController < ApplicationController
  before_filter :admin_login_required

  respond_to :html, :json

  layout 'dashboard'

  # GET /companies
  # GET /companies.xml
  def index
    # @companies = current_account.companies.includes(:contacts).order('name asc').page(params[:page]).per(50)
    @companies = Company.all
    @company = Company.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  def archived
    @companies = Company.archived_companies
    respond_to do |format|
      format.html # clients.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])
    @contact = @company.contacts.first
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new
    @company.image = params[:file]

    # if params[:status_id]
    #   @company.status_id = params[:status_id]
    # else
    #   @company.status_id = 1
    # end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js   {render :action => "edit"}
      format.xml  { render :xml => @contact }
    end
  end

  def archive
    @company = Company.find(params[:id])
    @company.archived = 1
    @company.save
    flash[:notice] = "The company has been archived"
    redirect_to :action => "index"
  end

  def unarchive
    @company = Company.find(params[:id])
    @company.archived = 0
    @company.save
    flash[:notice] = "The company has been archived"
    redirect_to :action => "archived"
  end

  def search
    if params[:search] and not params[:search][:query].empty?
      @query = "%#{params[:search][:query]}%"
      @companies = Company.includes(:contacts).where("companies.name like ?", @query).order('companies.name asc').page(params[:page]).per(50)
    end
    @companies ||= Company.includes(:contacts).order('companies.name asc').page(params[:page]).per(50)
    @company = Company.new
    respond_to do |format|
      format.html { render :template => 'dashboard/companies/index'}# index.html.erb
      format.js { render layout: false}
      format.xml  { render :xml => @companies }
    end
  end

  def auto_complete_for_search_query
    @account = current_account
    if params[:search] and not params[:search][:query].empty?
      @query = params[:search][:query]
      @companies = current_account.companies.find(:all, :conditions => "name like '%#{@query}%' OR phone like '%#{@query}%'")
      #@companies = Company.search @query, :with => {:account_id => current_account.id}
    else
      @companies = @account.companies
    end

  end

  def list_company_locations_for_model
    @company = Company.find(params[:id])
    @model = params[:model]
    respond_to do |format|
      format.html { render '_list_company_locations_for_model'}
    end
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])
    respond_to do |format|
      if @company.update_attributes(company_params)
        flash[:notice] = 'Company was successfully updated.'
        format.js   { render :js => 'window.location.reload()' }
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(dashboard_companies_url) }
      format.xml  { head :ok }
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :archived, :city, :image, :image_cache, :phone, :postal_code, :state, :street1, :street2, :website, :facebook_handle, :twitter_handle)
  end
end
