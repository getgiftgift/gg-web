class Dashboard::SponsorshipsController < Dashboard::BaseController

  def index
    @sponsorships = Sponsorship.all.order(end_date: :desc)
  end

  def new
    @sponsorship = Sponsorship.new
  end

  def create
    @sponsorship = Sponsorship.new(sponsorship_params)
    if @sponsorship.save
      redirect_to :index
    else
      render :new
    end

  end


  private

  def sponsorship_params
    params.permit(:sponsorship)

  end  
end
