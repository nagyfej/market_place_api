require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show " do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = json(response.body)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @attributes = FactoryGirl.attributes_for :user
        post :create, {user: @attributes }, format: :json
      end

      it "renders the json representation for the user object just created" do
         user_response = json(response.body)
         expect(user_response[:email]).to eql @attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_attributes = { password: '123456789', password_confirmation: '123456789' }
        post :create, { user: @invalid_attributes }, format: :json
      end

      it "renders an error" do
        user_response = json(response.body)
        expect(user_response).to have_key(:errors)
      end

      it "renders the specific error for the email attribute error" do
        user_response = json(response.body)
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
        patch :update, { id: @user.id, user: { email: "new-valid-email@example.com" } }, format: :json
      end

      it "renders user object with the updated attributes" do
        user_attributes = json(response.body)
        expect(user_attributes[:email]).to eql "new-valid-email@example.com"
      end

      it { should respond_with 200 }
    end

    context "when can't be updated" do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "new-invalid-email" } }, format: :json
        @user_response = json(response.body)
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
      delete :destroy, { id: @user.id }, format: :json
    end

    it { should respond_with 204 }

  end

end
