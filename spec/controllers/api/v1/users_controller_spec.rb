require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}" }
  before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }

  describe "GET #show " do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @attributes = FactoryGirl.attributes_for :user
        post :create, {user: @attributes }
      end

      it "renders the json_response representation for the user object just created" do
         user_response = json_response
         expect(user_response[:email]).to eql @attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_attributes = { password: '123456789', password_confirmation: '123456789' }
        post :create, { user: @invalid_attributes }
      end

      it "renders an error" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the specific error for the email attribute error" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "new-valid-email@example.com" } }
      end

      it "renders user object with the updated attributes" do
        user_attributes = json_response
        expect(user_attributes[:email]).to eql "new-valid-email@example.com"
      end

      it { should respond_with 200 }
    end

    context "when can't be updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "new-invalid-email" } }
        @user_response = json_response
      end

      it "renders an error" do
        expect(@user_response).to have_key(:errors)
      end

      it "renders the specific error for the email attribute error" do
        expect(@user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end

  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }

  end

end
