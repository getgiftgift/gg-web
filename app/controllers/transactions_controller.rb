class TransactionsController < ApplicationController
	
	skip_filter :verify_login_and_birthday
	def new
		@token = Braintree::ClientToken.generate
		@transaction = Transaction.new	
	end

	def create
		@party = BirthdayParty.find(params[:id])
		amount = Monetize.parse(params[:amount])
		@result = Braintree::Transaction.sale(
			amount: amount.to_s, 
			payment_method_nonce: params[:payment_method_nonce],
			options: {
				:submit_for_settlement => true
			}
		)

		transaction = @result.transaction
		
		BraintreeTransaction.create(
			birthday_party: @party,
			transaction_id: transaction.id,
			amount: Monetize.parse(transaction.amount),
			processor: Transaction::BRAINTREE, 
			status: transaction.status,
			name: params[:name].presence || 'Anonymous',
			note: params[:note].presence || 'Happy birthday!'
			)

		redirect_to birthday_party_path(@party)
	end

	
end
