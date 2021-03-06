require 'spec_helper'

describe Admin::Offer::DealsController do
  render_views

  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action renders index template" do
    deal = create(:deal)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action renders show template" do
    deal = create(:deal)
    get :show, :id => deal.id
    expect(response).to render_template(:show)
  end

  it "new action renders new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action renders new template when model is invalid" do
    deal = FactoryGirl.build(:deal)
    Deal.any_instance.stubs(:valid?).returns(false)
    post :create, :deal => deal.attributes.except('id', 'deleted_at', 'created_at', 'updated_at')
    expect(response).to render_template(:new)
  end

  it "create action redirects when model is valid" do
    deal = FactoryGirl.build(:deal)
    Deal.any_instance.stubs(:valid?).returns(true)
    post :create, :deal => deal.attributes.except('id', 'deleted_at', 'created_at', 'updated_at')
    expect(response).to redirect_to(admin_offer_deal_url(assigns[:deal]))
  end

  it "edit action renders edit template" do
    deal = create(:deal)
    get :edit, :id => deal.id
    expect(response).to render_template(:edit)
  end

  it "update action renders edit template when model is invalid" do
    deal = create(:deal)
    Deal.any_instance.stubs(:valid?).returns(false)
    put :update, :id => deal.id, :deal => deal.attributes.except('id', 'deleted_at', 'created_at', 'updated_at')
    expect(response).to render_template(:edit)
  end

  it "update action redirects when model is valid" do
    deal = create(:deal)
    Deal.any_instance.stubs(:valid?).returns(true)
    put :update, :id => deal.id, :deal => deal.attributes.except('id', 'deleted_at', 'created_at', 'updated_at')
    expect(response).to redirect_to(admin_offer_deal_url(assigns[:deal]))
  end

  it "destroy action should destroy model and redirect to index action" do
    deal = create(:deal)
    delete :destroy, :id => deal.id
    expect(response).to redirect_to(admin_offer_deals_url)
    Deal.find(deal.id).deleted_at.should_not be_nil
  end
end
