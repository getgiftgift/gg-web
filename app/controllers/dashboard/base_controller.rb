class Dashboard::BaseController < ApplicationController
  layout 'dashboard'
  skip_filter :verify_login_and_birthday
  before_filter :admin_login_required
end