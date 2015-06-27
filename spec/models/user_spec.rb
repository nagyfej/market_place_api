require 'spec_helper'

describe User do

  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:avatar) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

end
