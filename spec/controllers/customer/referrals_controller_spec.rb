require 'spec_helper'

describe Customer::ReferralsController do
  render_views

  before(:each) do
    activate_authlogic
    @user = FactoryGirl.create(:user)
    login_as(@user)
  end
  
  it "index action renders index template" do
    referral = FactoryGirl.create(:referral)
    get :index
    expect(response).to render_template(:index)
  end

  it "create action renders new template when model is invalid" do
    referral = FactoryGirl.build(:referral, :referring_user_id => @user.id)
    Referral.any_instance.stubs(:valid?).returns(false)
    post :create, :referral => referral.attributes.reject {|k,v| ['id','applied','clicked_at','purchased_at', 'referral_user_id', 'referral_program_id', 'referring_user_id', 'registered_at','sent_at', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:index)
  end

  it "create action redirects when model is valid" do
    referral = FactoryGirl.build(:referral, :referring_user_id => @user.id)
    referral_mock = mock()
    referral_mock.expects(:deliver).once
    UserMailer.stubs(:referral_invite).returns(referral_mock)
    post :create, :referral => referral.attributes.reject {|k,v| ['id','applied','clicked_at','purchased_at', 'referral_user_id', 'referral_program_id', 'referring_user_id', 'registered_at','sent_at', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(customer_referrals_url)
  end

  it "update action renders edit template when model is invalid" do
    referral = FactoryGirl.create(:referral, :referring_user_id => @user.id)
    Referral.any_instance.stubs(:valid?).returns(false)
    put :update, :id => referral.id, :referral => referral.attributes.reject {|k,v| ['id','applied','clicked_at','purchased_at', 'referral_user_id', 'referral_program_id', 'referring_user_id', 'registered_at','sent_at', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:index)
  end

  it "update action redirects when model is valid" do
    referral = FactoryGirl.create(:referral, :referring_user_id => @user.id)
    Referral.any_instance.stubs(:valid?).returns(true)
    put :update, :id => referral.id, :referral => referral.attributes.reject {|k,v| ['id','applied','clicked_at','purchased_at', 'referral_user_id', 'referral_program_id', 'referring_user_id', 'registered_at','sent_at', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(customer_referrals_url)
  end
end
