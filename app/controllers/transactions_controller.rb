class TransactionsController < ApplicationController
	
	skip_filter :verify_login_and_birthday
	def new
		@token = Braintree::ClientToken.generate
		@transaction = Transaction.new	
	end

	def create
		@result = Braintree::Transaction.sale(
			amount: "", 
			payment_method_nonce: "",
			options: {}
		
		)

	end

	
end
