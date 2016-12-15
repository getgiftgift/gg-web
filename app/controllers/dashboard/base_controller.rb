class Dashboard::BaseController < ApplicationController
  layout 'dashboard'

  before_filter :admin_login_required

end