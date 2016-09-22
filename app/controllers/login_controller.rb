class LoginController < ApplicationController
  def login
  end

  def login_handler
    user_login = params[:login]
    user_password = params[:password]
    c = Client.where(:login=>user_login,:password=>user_password).first()

    if(c!=nil)
      session[:login] = c.login
      redirect_to "/chat"
    end
  end
end
