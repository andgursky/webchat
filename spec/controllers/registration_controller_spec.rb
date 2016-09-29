require 'rails_helper'

RSpec.describe RegistrationController, type: :controller do
  describe "POST #registration_handler" do
    render_views

    describe "when we have new client" do
      reg_params = { :user_name=>"new_name", :user_login=>"new_login",
                     :user_password=>"new_password" }

      it "redirects to '/' if client doesn't exist in 'Clients' db" do
        post :registration_handler, reg_params
        expect(response).to redirect_to("/")
      end

      it "save new user if client doesn't exist" do
        expect_any_instance_of(Client).to receive(:save).and_call_original
        post :registration_handler, reg_params
      end
    end

    describe "when the old client trying to register with his credentials" do
      client = FactoryGirl.create(:client)

      reg_params = { :user_name=>client.name,
                     :user_login=>client.login,
                     :user_password=>client.password }

      it "shows 'Login incorrect' on the /registration_handler page" do
        post :registration_handler, reg_params
        expect(response.body).to include("Login incorrect")
      end

      it "renders /registration_handler page" do
        post :registration_handler, reg_params
        expect(response).to render_template("registration_handler")
      end
    end
  end
end
