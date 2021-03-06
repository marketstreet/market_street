require 'spec_helper'

describe Admin::Fulfillment::OrdersController do
  render_views

  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "show action renders show template" do
    @order = create(:order)
    get :show, :id => @order.number
    expect(response).to render_template(:show)
  end

  it "index action renders index template" do
    get :index
    expect(response).to render_template(:index)
  end
end
