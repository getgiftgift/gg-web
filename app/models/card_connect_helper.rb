# Plain-old Ruby class for managing interactions with CardConnect via the 'cardconnect' gem.
class CardConnectHelper

  TRANSACTION_FEE = 0.25
  TRANSACTION_CURRENCY = 'USD'
  TRANSACTION_COUNTRY = 'US'

  def initialize(user, voucher)
    @user = user
    @voucher = voucher
  end

  def charge_without_profile(params)
    params = params.merge( merchid: ENV['CARDCONNECT_MERCHANT_ID'],
                           amount: TRANSACTION_FEE.to_s,
                           currency: TRANSACTION_CURRENCY,
                           country: TRANSACTION_COUNTRY,
                           tokenize: 'Y',
                           profile: 'Y')
    puts params.inspect
    auth_service = CardConnect::Service::Authorization.new
    auth_service.build_request(params)
    auth_response = auth_service.submit

    puts auth_response.inspect

    case auth_response.respstat
    when 'A'
      # Approved
      capture_result = capture(auth_response)
      if capture_result[:result]
        create_card_profile!(params, auth_response)
      end
      return capture_result.merge(auth_response: auth_response)
    when 'B'
      # Retry
      return {result: false, error: 'Your card could not be charged at this time. Please retry later.', response: auth_response}
    when 'C'
      # Declined
      return {result: false, error: 'Payment method declined.', response: auth_response}
    end
  end

  def charge_with_profile(credit_card_profile, params)
    params = params.merge( merchid: ENV['CARDCONNECT_MERCHANT_ID'],
                           amount: TRANSACTION_FEE.to_s,
                           currency: TRANSACTION_CURRENCY,
                           country: TRANSACTION_COUNTRY,
                           tokenize: 'Y',
                           profile: credit_card_profile.cardconnect_profileid)
    puts params.inspect
    auth_service = CardConnect::Service::Authorization.new
    auth_service.build_request(params)
    auth_response = auth_service.submit

    puts auth_response.inspect

    case auth_response.respstat
    when 'A'
      # Approved
      capture_result = capture(auth_response)
      return capture_result.merge(auth_response: auth_response)
    when 'B'
      # Retry
      return {result: false, error: 'Your card could not be charged at this time. Please retry later.', response: auth_response}
    when 'C'
      # Declined
      return {result: false, error: 'Payment method declined.', response: auth_response}
    end
  end

private

  def capture(auth_response)
    capture_service = CardConnect::Service::Capture.new
    params = { merchid: ENV['CARDCONNECT_MERCHANT_ID'], retref: auth_response.retref }
    capture_service.build_request(params)
    capture_response = capture_service.submit
    puts capture_response.inspect
    result = case capture_response.setlstat
    when 'Txn not found'
      {result: false, error: 'Transaction not found'}
    when 'Authorized'
      {result: true}
    when 'Queued for Capture'
      {result: true}
    when 'Zero Amount'
      {result: false, error: 'Payment method declined (authorization voided)'}
    when 'Accepted'
      {result: true}
    when 'Rejected'
      {result: false, error: 'Payment method declined'}
    end
    if result[:result]
      create_transaction!(capture_response)
    end
    result.merge(capture_response: capture_response)
  end

  def create_card_profile!(params, auth_response)
    last4 = params[:account].delete('^-0-9').split(//).last(4).join
    CreditCardProfile.create!(user: @user,
                              cardconnect_profileid: auth_response.profileid,
                              expiry: params[:expiry],
                              card_type: params[:accttype],
                              last4: last4)
  end

  def create_transaction!(capture_response)
      Transaction.create!(
        transaction_id: capture_response.retref,
        amount: Monetize.parse(capture_response.amount),
        voucher: @voucher,
        birthday_party: @voucher.birthday_party)
  end

end
