require 'spec_helper'

describe Api::V1::OrdersController do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, { user_id: current_user.id }
    end

    it "returns 4 orders related to the user" do
      expect(json_response[:orders].size).to eq(4) 
    end

    it { should respond_with 200 }

  end

end
