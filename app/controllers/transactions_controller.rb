class TransactionsController < ApplicationController

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
