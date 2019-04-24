class TransactionsController < ApplicationController
	skip_filter :verify_login_and_birthday
	
	helper_method :voucher, :party, :saved_user_payment_token

	def new
		if saved_user_payment_token
			@payment_method = gateway.payment_method.find(saved_user_payment_token)
		end 
		@transaction = Transaction.new
		@party = current_user.birthday_party
	end

	def create
		if params[:payment] == 'new'
			redirect_to [:new_payment_method, voucher] and return
		end
		amount = params[:amount]
		if params[:payment] == 'existing' 
			result = gateway.transaction.sale(
				amount: amount,
				payment_method_token: params[:payment_method_token],
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
			response = result.transaction
			flash[:success] = 'Payment processed successfullly!'
			current_user.update(payment_token: response.credit_card_details.token)
			Transaction.create( 
				transaction_id: response.id, 
				amount: Monetize.parse(response.amount),
				voucher: voucher,
				birthday_party: party
			)
			voucher.make_redeemable!
			redirect_to :my_gifts
		else
			flash[:info] = 'There was an issue try again'
			render :new
		end

		
	end

	def new_payment_method
		@client_token = gateway.client_token.generate
	end

	private
		def gateway
			@gateway ||= Braintree::Gateway.new(
				:environment => :sandbox,
				:merchant_id => ENV["BRAINTREE_MERCHANT_ID"],
				:public_key => ENV["BRAINTREE_PUBLIC_KEY"],
				:private_key => ENV["BRAINTREE_PRIVATE_KEY"],
			)
		end
		
		def voucher
			@voucher ||= BirthdayDealVoucher.find params[:id]
		end

		def saved_user_payment_token
			@saved_user_payment_token ||= current_user.payment_token
		end

		def party
			@party ||= BirthdayParty.find params[:party_id]
		end
end