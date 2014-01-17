FactoryGirl.define do
  factory :invoice do
    order           { |c| c.association(:order) }
    amount          20.13
    state           'authorized'
    active          true
    invoice_type    'Purchase'
  end  
end
