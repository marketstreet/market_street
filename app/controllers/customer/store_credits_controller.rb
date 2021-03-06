class Customer::StoreCreditsController < Customer::BaseController

  def show
    @store_credit = current_user.store_credit
  end

  private

  def selected_customer_tab(tab)
    (tab == 'store_credit') ? 'active' : ''
  end
end
