require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }
  it "should respond to email, password and password confirmation" do
    expect(@user).to respond_to(:email)
    expect(@user).to respond_to(:password)
    expect(@user).to respond_to(:password_confirmation)
  end

  it { expect(@user).to validate_presence_of(:email) }
  it { expect(subject).to validate_uniqueness_of(:email) }
  it { expect(subject).to validate_confirmation_of(:password) }
  it { expect(subject).to allow_value('example@domain.com').for(:email) }
end
