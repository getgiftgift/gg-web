class CompaniesController < ApplicationController

  layout 'application'

  def new
    @company = Company.new
    @company.contacts.new
    @client_token = Braintree::ClientToken.generate
  end

  def create
    @company = Company.create(company_params)
    contact_params = company_params[:contacts_attributes]['0']
    result = Braintree::Customer.create(
      :first_name => contact_params[:first_name], 
      :last_name => contact_params[:last_name], 
      :company => company_params[:name], 
      :email => contact_params[:email],
      :payment_method_nonce => params[:payment_method_nonce]
    )  
    if result.success?
      response = result.customer.credit_cards[0]
      @company.contacts.first.update_attributes( 
        token: response.token, 
        cc_last_four: response.last_4,
        cc_card_type: response.card_type,
        cc_expiration_month: response.expiration_month,
        cc_expiration_year: response.expiration_year,
        gateway_customer_id: response.customer_id
      )
      flash[:notice] = "Successfully created #{@company.name}."
      redirect_to new_company_path

      ## Credit card verification
      # :options => {
      #   :verify_card => true
      # }
      # result.success?
      # #=> false

      # verification = result.credit_card_verification
      # verification.status
      # #=> "processor_declined"

      # verification.processor_response_code
      # #=> "2000"

      # verification.processor_response_text
      # #=> "Do Not Honor"
    else
      flash[:notice] = "Try again. #{result.errors.first.message}"
      @client_token = Braintree::ClientToken.generate
      render 'new'
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, contacts_attributes: [:id, :first_name, :last_name, :postal_code, :email, :company_id])
  end
end