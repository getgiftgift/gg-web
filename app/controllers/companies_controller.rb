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
      @company.contacts.first.update_attributes token: result.customer.credit_cards[0].token
      flash[:notice] = "Successfully created #{@company.name}."
      redirect_to new_company_path
    else
      flash[:notice] = "Try again. #{result.errors.first.message}"
      render 'new'
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, contacts_attributes: [:id, :first_name, :last_name, :postal_code, :email, :company_id])
  end
end