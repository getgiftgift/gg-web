class Subscription < ActiveRecord::Base

  belongs_to :user

  state_machine :state, initial: :new do 
    after_transition any => :pending_subscribe, :do => Proc.new {|subscription, *args| MailingList.delay.subscribe(subscription.user)}
    after_transition :subscribed => :pending_unsubscribe, :do => Proc.new {|subscription, *args| MailingList.delay.unsubscribe(subscription.user)}

    state :new
    state :inactive
    state :awaiting_confirmation
    state :pending_subscribe #delayed_job created. Waiting for call and commit from mailchimp
    state :subscribed #confirmed after api call to mailchimp
    state :pending_unsubscribe #delayed_job created. Waiting for call and commit from mailchimp
    state :unsubscribed #confirmed after api call to mailchimp

    event :create do
      transition :new => :inactive
    end

    event :subscribe do
      transition [:new, :inactive, :unsubscribed, :awaiting_confirmation] => :pending_subscribe #, :if => lambda{ |subscription| subscription.confirmed? }
      # transition [:inactive, :new] => :awaiting_confirmation
    end

    event :unsubscribe do
      transition :subscribed => :pending_unsubscribe
    end

    event :subscribe_confirmed do
      transition [:new, :pending_subscribe] => :subscribed
    end

    event :unsubscribe_confirmed do
      transition :pending_unsubscribe => :unsubscribed
    end

    event :confirm do
      transition :awaiting_confirmation => :pending_subscribe
      transition [:inactive, :new, :subscribed] => same
    end

  end

end