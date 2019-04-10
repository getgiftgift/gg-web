class TransactionsController < ApplicationController
	skip_filter :verify_login_and_birthday
	
	# store customers in vault
	# determine if: 
	# 	new cust new payment
	# 	exist cust new payment
	# 	exist cust saved payment
	
	

	def new 
		token = current_user.payment_token
		@payment_method = gateway.payment_method.find(token)
		@token = gateway.client_token.generate
		@transaction = Transaction.new
		@party = current_user.birthday_party
	end

	def new_payment_method
		@transaction = Transaction.new
		@party = current_user.birthday_party
	end

	def create
		return render 'new_payment_method' if params[:payment] == 'new'
		@party = BirthdayParty.find(params[:party_id])
		amount = Monetize.parse(params[:amount])
		if params[:payment] == 'existing' 
			result = gateway.transaction.sale(
				amount: amount.to_s,
				payment_method_token: params[:payment_method_nonce],
				options: {
					submit_for_settlement: true
				}
			)
		else
			result = gateway.transaction.sale(
				amount: amount.to_s,
				payment_method_nonce: params[:payment_method_nonce],
				options: {
					submit_for_settlement: true,
					store_in_vault_on_success: true
				}
			)
		end

		if result.success?
			current_user.update(payement_token: result.transaction.credit_card_details.token)
		end

		redirect_to birthday_party_path(@party)
	end

	private
		def gateway
			Braintree::Gateway.new(
				:environment => :sandbox,
				:merchant_id => ENV["BRAINTREE_MERCHANT_ID"],
				:public_key => ENV["BRAINTREE_PUBLIC_KEY"],
				:private_key => ENV["BRAINTREE_PRIVATE_KEY"],
			)
		end
end