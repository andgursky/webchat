require 'rails_helper'

RSpec.describe ChatController, type: :controller do
  describe "#chat" do
    it "redirects to '/' if login in session is nil" do
      get :chat, :login=>nil
      expect(response).to redirect_to('/')
    end
  end

  describe "#chat_handler" do
  end
end
