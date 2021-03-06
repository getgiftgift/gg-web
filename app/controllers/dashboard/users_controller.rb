class Dashboard::UsersController < Dashboard::BaseController
  before_filter :get_vouchers, only: [:show]

  # GET /users
  # GET /users.json
   def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user_bday = @user.birthdate.strftime('%m-%d-%Y') if @user.birthdate
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    # if params[:customer]
    #   month =  params[:customer]['birthdate(2i)'].to_i
    #   day = params[:customer]['birthdate(3i)'].to_i
    #   year = params[:customer]['birthdate(1i)'].to_i
    #   @user.birthdate = Date.new(year,month,day).to_s(:db)
    # end

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to dashboard_users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_users_url }
      format.json { head :no_content }
    end
  end


  def get_vouchers
    @user = User.find(params[:id])
    @birthday_vouchers = @user.birthday_deal_vouchers
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :birthdate)
    end

end
