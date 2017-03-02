class Dashboard::SponsorshipsController < Dashboard::BaseController

  def index
    @sponsorships = Sponsorship.all.order(end_date: :desc)
  end

  def show
    @sponsorship = Sponsorship.includes(:transactions).where(id: params[:id]).first
    @parties = BirthdayParty.includes(:transactions).available_to_sponsor
  end

  def edit
    @sponsorship = Sponsorship.find(params[:id])
  end

  def new
    @sponsorship = Sponsorship.new
  end

  def create
    @sponsorship = Sponsorship.new(sponsorship_params)
    if @sponsorship.save
      redirect_to dashboard_sponsorships_path
    else
      render new_dashboard_sponsorships_path
    end

  end

  def update
    @sponsorship = Sponsorship.find(params[:id])
    respond_to do |format|
      if @sponsorship.update_attributes(sponsorship_params)
        flash[:notice] = 'Sponsorship was successfully updated.'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sponsorship.errors, :status => :unprocessable_entity }
      end
    end
  end


  def sponsor
    party = BirthdayParty.find(params[:party_id])
    sponsorship = Sponsorship.find(params[:id])
    sponsorship.transactions.create(
      birthday_party: party,
      amount: sponsorship.amount_per_party,
      status: 'complete',
      name: sponsorship.name,
      note: sponsorship.note
      )
    redirect_to dashboard_sponsorship_path(sponsorship)
  end


  private

  def sponsorship_params
    params.require(:sponsorship).permit(:name, :note, :amount_per_party, :total_amount, :start_date, :end_date)
  end
end
