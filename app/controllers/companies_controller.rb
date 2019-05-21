class CompaniesController < ApplicationController

  layout 'application'

  def new
    @company = Company.new
    @company.contacts.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
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