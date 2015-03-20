class HomeController < ApplicationController

  def dashboard
    if current_user && current_user.admin?
      redirect_to dashboard_index_path
    else
      redirect_to new_user_session_path
    end
  end
  
end