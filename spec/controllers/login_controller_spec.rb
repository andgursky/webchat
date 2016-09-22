require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe "POST #login_handler" do
    client = FactoryGirl.create(:client, login: "John", password: "111")
    render_views

    describe "with valid credentials" do
      it 'returns status 302' do
        post :login_handler, { :login=>client.login,
                               :password=>client.password }
        expect(response.status).to eq(302)
      end

      it 'renders "/chat" if client exist' do
        post :login_handler, { :login=>client.login,
                               :password=>client.password }
        expect(response).to redirect_to(chat_path)
      end
    end

    describe "with invalid credentials" do
      it "returns status 200" do
        post :login_handler, { :login=>"fake_login",
                               :password=>"fake_pass" }
        expect(response.status).to eq(200)
      end

      it "renders '/login_handler' if client does not exist" do
        post :login_handler, { :login=>"fake_login",
                               :password=>"fake_pass" }
        expect(response).to render_template('/')
      end

      it "renders page with 'Login Incorrect' content if client does not
      exist" do
        post :login_handler, { :login=>"fake_login",
                               :password=>"fake_pass" }
        expect(response.body).to include("Login incorrect")
      end
    end
  end
end
