class Dashboard::BaseController < ApplicationController
  layout 'dashboard'

  before_filter :admin_login_required
  skip_filter :verify_login_and_birthday
end