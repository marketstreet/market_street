require 'spec_helper'

describe HomeController do
  render_views

  it "show action renders index template" do
    FactoryGirl.create_list(:product, 2)
    get :index
    expect(response).to be_success
  end

  it "redirects to login page if no featured products" do 
    get :index
    expect(response).to redirect_to login_path
  end

  it "show action renders about template" do
    get :about
    expect(response).to be_success
  end

  it "show action renders terms template" do
    get :terms
    expect(response).to be_success
  end
end
