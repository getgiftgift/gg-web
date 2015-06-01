class Dashboard::ContactsController < ApplicationController

  layout 'dashboard'

  def new
    @client_token = Braintree::ClientToken.generate
    @company = Company.find params[:company_id]
    @contact = @company.contacts.new
  end

  def create
    @company = Company.find params[:company_id]
    @contact = @company.contacts.create(contact_params)

    result = Braintree::Customer.create(
      :first_name => params[:contact][:first_name], 
      :last_name => params[:contact][:last_name], 
      :company => params[:contact][:name], 
      :email => params[:contact][:email],
      :payment_method_nonce => params[:payment_method_nonce]
    )  
    if result.success?
      response = result.customer.credit_cards[0]
      @company.contacts.first.update_attributes( 
        token: response.token,
        cardholder_name: response.cardholder_name, 
        cc_last_four: response.last_4,
        cc_card_type: response.card_type,
        cc_expiration_month: response.expiration_month,
        cc_expiration_year: response.expiration_year,
        postal_code: result.customer.addresses[0].postal_code,
        gateway_customer_id: response.customer_id
      )
      flash[:notice] = "Successfully created #{@company.name}."
      redirect_to dashboard_company_path(@company)

    else
      flash[:notice] = "Try again. #{result.errors.first.message}"
      @client_token = Braintree::ClientToken.generate
      render 'new'
    end  
  end

  def update
    byebug
    @company = Company.find params[:company_id]
    @contact = @company.contacts.first
    @contact.update_attributes(contact_params)
    result = Braintree::Customer.update( @contact.gateway_customer_id,
      :first_name => contact_params[:first_name], 
      :last_name => contact_params[:last_name], 
      :company => @company.name, 
      :email => contact_params[:email],
      :payment_method_nonce => params[:payment_method_nonce]
    )  
    if result.success?
      response = result.customer.credit_cards[0]
      @company.contacts.first.update_attributes( 
        token: response.token,
        cardholder_name: response.cardholder_name, 
        cc_last_four: response.last_4,
        cc_card_type: response.card_type,
        cc_expiration_month: response.expiration_month,
        cc_expiration_year: response.expiration_year,
        postal_code: result.customer.addresses[0].postal_code,
        gateway_customer_id: response.customer_id
      )
      flash[:notice] = "Successfully updated #{@company.name}."
      redirect_to dashboard_company_path(@company)
    else
      @client_token = Braintree::ClientToken.generate
      render 'edit'
    end  
  end

  def edit
    @client_token = Braintree::ClientToken.generate
    @company = Company.find params[:company_id]
    @contact = Contact.find params[:id]
  end










private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end

end