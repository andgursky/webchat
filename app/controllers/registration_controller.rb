class RegistrationController < ApplicationController
  def registration
  end

  def registration_handler
    client_name = params["name"]
    client_login = params["login"]
    client_password = params["password"]

    if(Client.find_by_login(client_login)==nil)
      u = Client.new(:name=>client_name,
                     :login=>client_login,
                     :password=>client_password)
      u.save
      redirect_to "/"
    end
  end
end
