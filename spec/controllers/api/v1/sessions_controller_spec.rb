require 'spec_helper'

describe Api::V1::SessionsController do

  before(:each) do
    @user = FactoryGirl.create :user
  end

  describe "POST #create" do

    context "when the credentials are correct" do

      before(:each) do
        credentials = { email: @user.email, password: "123456789" }
        post :create, { session: credentials }
      end

      it "returns the user object" do
        @user.reload
        expect(json_response[:user][:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalid_password" }
        post :create, { session: credentials }
      end

      it "returns an auth error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end

  end

  describe "DELETE #destroy" do

    before(:each) do
      #sing_in :user, @user, store: false
      credentials = { email: @user.email, password: "123456789" }
      post :create, { session: credentials }
      @user.reload
      @old_token = @user.auth_token
      delete :destroy, id: @old_token
    end

    it "have a different auth_token than bedore" do
      @user.reload
      expect(@user.auth_token).not_to eql @old_token
    end
    it { should respond_with 204 }

  end

end
