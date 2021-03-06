require 'spec_helper'

describe Admin::Fulfillment::ReturnAuthorizationsController do
  render_views

  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
    @order = create(:completed_order)
  end

  it "index action renders index template" do
    @return_authorization = create(:return_authorization)
    get :index, :order_id => @order.id
    expect(response).to render_template(:index)
  end

  it "show action renders show template" do
    @return_authorization = create(:return_authorization)
    get :show, :id => @return_authorization.id, :order_id => @order.id
    expect(response).to render_template(:show)
  end

  it "new action renders new template" do
    get :new, :order_id => @order.id
    expect(response).to render_template(:new)
  end

  it "create action renders new template when model is invalid" do
    ReturnAuthorization.any_instance.stubs(:valid?).returns(false)
    post :create, :order_id => @order.id, :return_authorization => {:amount => '12.60', :user_id => 1}
    expect(response).to render_template(:new)
  end

  it "create action redirects when model is valid" do
    ReturnAuthorization.any_instance.stubs(:valid?).returns(true)
    post :create, :order_id => @order.id, :return_authorization => {:amount => '12.60', :user_id => 1}
    expect(response).to redirect_to(admin_fulfillment_order_return_authorization_url(@order, assigns[:return_authorization]))
  end

  it "edit action renders edit template" do
    @return_authorization = create(:return_authorization)
    get :edit, :id => @return_authorization.id, :order_id => @order.id
    expect(response).to render_template(:edit)
  end

  it "update action renders edit template when model is invalid" do
    @return_authorization = create(:return_authorization)
    ReturnAuthorization.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @return_authorization.id, :order_id => @order.id, :return_authorization => {:amount => '12.60', :user_id => 1}
    expect(response).to render_template(:edit)
  end

  it "update action redirects when model is valid" do
    @return_authorization = create(:return_authorization)
    ReturnAuthorization.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @return_authorization.id, :order_id => @order.id, :return_authorization => {:amount => '12.60', :user_id => 1}
    expect(response).to redirect_to(admin_fulfillment_order_return_authorization_url(@order, assigns[:return_authorization]))
  end

  it "update action redirects when model is valid" do
    @return_authorization = create(:return_authorization)
    ReturnAuthorization.any_instance.stubs(:valid?).returns(true)
    put :complete, :id => @return_authorization.id, :order_id => @order.id, :return_authorization => {:amount => '12.60', :user_id => 1}
    ReturnAuthorization.find(@return_authorization.id).state.should == 'complete'
  end

  it "destroy action should destroy model and redirect to index action" do
    @return_authorization = create(:return_authorization)
    delete :destroy, :id => @return_authorization.id, :order_id => @order.id
    expect(response).to redirect_to(admin_fulfillment_order_return_authorization_url(@order, @return_authorization))
    ReturnAuthorization.find(@return_authorization.id).state.should == 'cancelled'
  end
end
