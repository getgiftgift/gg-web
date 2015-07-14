class SubscriptionsController < ApplicationController
  respond_to :js

  def subscribe
    @sub = Subscription.find params[:id]
    @sub.subscribe!
  end

  def unsubscribe
    @sub = Subscription.find params[:id]
    @sub.unsubscribe!
  end
end