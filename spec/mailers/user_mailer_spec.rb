describe UserMailer, "Signup Email" do
    #include EmailSpec::Helpers
    #include EmailSpec::Matchers
    #include ActionController::UrlWriter
    include Rails.application.routes.url_helpers

    before(:each) do
      #"jojo@yahoo.com", "Jojo Binks"
      #[first_name.capitalize, last_name.capitalize ]
      @user  = create(:user, :email => 'myfake@email.com', :first_name => 'Dave', :last_name => 'Commerce')
      @email = UserMailer.signup_notification(@user.id)
    end

    it "is set to be delivered to the email passed in" do
      @email.should deliver_to("Dave Commerce <myfake@email.com>")
    end

    it "contains the user's message in the mail body" do
      @email.should have_body_text(/Dave Commerce/)
    end

    #it "contains a link to the confirmation link" do
    #  @email.should have_body_text(/#{confirm_account_url}/)
    #end

    it "has the correct subject" do
      @email.should have_subject(/Welcome/)
    end
end

describe UserMailer, "#new_referral_credits" do
  include Rails.application.routes.url_helpers

  before(:each) do
    @referring_user = create(:user,     :email => 'referring_user@email.com', :first_name => 'Dave', :last_name => 'Commerce')
    @referral       = create(:referral, :email => 'referral_user@email.com', :referring_user => @referring_user )
    @referral_user  = create(:user,     :email => 'referral_user@email.com', :first_name => 'Dave', :last_name => 'referral')

    #@referral_user.stubs(:referree).returns(@referral)
    @email = UserMailer.new_referral_credits(@referring_user.id, @referral_user.id)
  end
  it "is set to be delivered to the email passed in" do
    @email.should deliver_to("Dave Commerce <referring_user@email.com>")
  end

  it "has the correct subject" do
    @email.should have_subject(/Referral Credits have been Applied/)
  end
end


describe UserMailer, "#referral_invite(referral_id, inviter_id)" do
  include Rails.application.routes.url_helpers

  before(:each) do
    @referring_user = create(:user,     :email => 'referring_user@email.com', :first_name => 'Dave', :last_name => 'Commerce')
    @referral       = create(:referral, :email => 'referral_user@email.com', :referring_user => @referring_user )

    #@referral_user.stubs(:referree).returns(@referral)
    @email = UserMailer.referral_invite(@referral.id, @referring_user.id)
  end
  it "is set to be delivered to the email passed in" do
    @email.should deliver_to("referral_user@email.com")
  end

  it "has the correct subject" do
    @email.should have_subject(/Referral from Dave/)
  end
end

describe UserMailer, "#order_confirmation" do
    include Rails.application.routes.url_helpers

    before(:each) do
      @user         = create(:user, :email => 'myfake@email.com', :first_name => 'Dave', :last_name => 'Commerce')
      @order_item   = create(:order_item)
      @order        = create(:order, :email => 'myfake@email.com', :user => @user)
      @invoice        = create(:invoice, :order => @order)
      @order.stubs(:order_items).returns([@order_item])
      @email = UserMailer.order_confirmation(@order.id, @invoice.id)
    end

    it "is set to be delivered to the email passed in" do
      @email.should deliver_to("myfake@email.com")
    end

    it "contains the user's message in the mail body" do
      @email.should have_body_text(/Dave Commerce/)
    end

    #it "contains a link to the confirmation link" do
    #  @email.should have_body_text(/#{confirm_account_url}/)
    #end

    it "has the correct subject" do
      @email.should have_subject(/Order Confirmation/)
    end

end