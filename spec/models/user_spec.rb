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

  it { should respond_to(:auth_token) }
  it { should validate_uniqueness_of(:auth_token) }
  it { should have_many(:products) }

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  describe "#products association" do
    before do
      @user.save
      3.times { FactoryGirl.create :product, user: @user }
    end

    it "destroys the associated products on self destruct" do
      products = @user.products
      @user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
        endgit
    end
  end
end
