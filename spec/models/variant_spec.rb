require 'spec_helper'

describe Variant, " instance methods" do
  before(:each) do
    @variant = create(:variant)
  end
  
  # OUT_OF_STOCK_QTY = 0
  # LOW_STOCK_QTY    = 2
  context ".sold_out?" do
    it 'is sold out' do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => (100 - Variant::OUT_OF_STOCK_QTY))
      @variant    = create(:variant,   :inventory => inventory)
      @variant.sold_out?.should be_true
    end

    it 'is not sold out' do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => (99 - Variant::OUT_OF_STOCK_QTY))
      @variant    = create(:variant,   :inventory => inventory)
      @variant.sold_out?.should be_false
    end
  end

  context ".low_stock?" do
    it 'is low stock' do
      inventory = create( :inventory, :count_on_hand => 100, 
                          :count_pending_to_customer => (100 - Variant::LOW_STOCK_QTY))
      @variant = create(:variant,   :inventory => inventory)
      @variant.low_stock?.should be_true
    end

    it 'is not low stock' do
      inventory = create( :inventory, :count_on_hand => 100, 
                          :count_pending_to_customer => (99 - Variant::LOW_STOCK_QTY))
      @variant = create(:variant,   :inventory => inventory)
      @variant.low_stock?.should be_false
    end
  end

  context ".display_stock_status(start = '(', finish = ')')" do
    it 'is low stock' do

      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => (100 - Variant::LOW_STOCK_QTY))
      @variant    = create(:variant,   :inventory => inventory)
      @variant.display_stock_status.should == '(Low Stock)'
    end

    it 'is sold out' do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => (100 - Variant::OUT_OF_STOCK_QTY))
      @variant    = create(:variant,   :inventory => inventory)
      @variant.display_stock_status.should == '(Sold Out)'
    end
  end

  context ".display_property_details(separator = '<br/>')" do
    # variant_properties.collect {|vp| [vp.property.display_name ,vp.description].join(separator) }
    it 'show all property details' do
      property      = create(:property)
      property.stubs(:display_name).returns('Color')
      variant_prop1 = create(:variant_property, :property => property, :description => 'red')
      variant_prop2 = create(:variant_property, :property => property, :description => 'blue')
      @variant.variant_properties.push(variant_prop1)
      @variant.variant_properties.push(variant_prop2)
      @variant.display_property_details.should == 'Color: red<br/>Color: blue'
    end
  end

  context ".property_details(separator = ': ')" do
    it 'show the property details' do
      property      = create(:property)
      property.stubs(:display_name).returns('Color')
      variant_prop1 = create(:variant_property, :property => property, :description => 'red')
      variant_prop2 = create(:variant_property, :property => property, :description => 'blue')
      @variant.variant_properties.push(variant_prop1)
      @variant.variant_properties.push(variant_prop2)
      @variant.property_details.should == ['Color: red', 'Color: blue']
    end
    it 'show the property details without properties' do
      @variant.property_details.should == []
    end
  end

  context ".product_name" do
    it 'returns the variant name' do
      @variant.name = 'helloo'
      @variant.product.name = 'product says hello'
      @variant.product_name.should == 'helloo'
    end

    it 'returns the products name' do
      @variant.name = nil
      @variant.product.name = 'product says hello'
      @variant.product_name.should == 'product says hello'
    end

    it 'returns the products name and subname' do
      @variant.name = nil
      @variant.product.name = 'product says hello'
      @variant.stubs(:primary_property).returns  create(:variant_property, :description => 'pp_name')
      @variant.product_name.should == 'product says hello - pp_name'
    end
  end

  context ".sub_name" do
    it 'returns the variants subname' do
      @variant.name = nil
      @variant.product.name = 'product says hello'
      @variant.stubs(:primary_property).returns  create(:variant_property, :description => 'pp_name')
      @variant.sub_name.should == 'pp_name'
    end
  end

  context ".primary_property" do
    it 'returns the primary property' do
      property      = create(:property)
      property2      = create(:property)
      property.stubs(:display_name).returns('Color')
      variant_prop1 = create(:variant_property, :variant => @variant, :property => property, :primary => true)
      variant_prop2 = create(:variant_property, :variant => @variant, :property => property2, :primary => false)
      @variant.variant_properties.push(variant_prop2)
      @variant.variant_properties.push(variant_prop1)
      @variant.primary_property.should == variant_prop1
    end

    it 'returns the primary property' do
      property      = create(:property)
      property2      = create(:property)
      property.stubs(:display_name).returns('Color')
      variant_prop1 = create(:variant_property, :variant => @variant, :property => property, :primary => true)
      variant_prop2 = create(:variant_property, :variant => @variant, :property => property2, :primary => false)
      @variant.variant_properties.push(variant_prop1)
      @variant.variant_properties.push(variant_prop2)
      @variant.save
      @variant.primary_property.should == variant_prop1
    end
  end

  context ".name_with_sku" do
    it "shows name_with_sku" do
      @variant.name = 'helloo'
      @variant.sku = '54321'
      @variant.name_with_sku.should == 'helloo: 54321'
    end
  end

  context ".qty_to_add" do
    it "returns 0 for qty_to_add" do
      @variant.qty_to_add.should == 0
    end
  end

  context ".is_available?" do
    it "is available" do
      inventory = create(:inventory, :count_on_hand => 100, 
        :count_pending_to_customer => 99)
      @variant = create(:variant, :inventory => inventory)
      @variant.save
      @variant.is_available?.should be_true
    end

    it "is not available" do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 100)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.is_available?.should be_false
    end
  end

  context ".count_available(reload_variant = true)" do
    it "returns count_available" do

      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 99)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.is_available?.should be_true
    end
  end

  context ".add_count_on_hand(num)" do
    it "updates count_on_hand" do

      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 99)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.add_count_on_hand(1)
      @variant.reload
      @variant.inventory.count_on_hand.should == 101
    end
  end

  context ".subtract_count_on_hand(num)" do
    it "updates count_on_hand" do

      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 99)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.subtract_count_on_hand(1)
      @variant.reload
      @variant.inventory.count_on_hand.should == 99
    end
  end

  context ".add_pending_to_customer(num)" do
    it "updates count_on_hand" do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 99)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.add_pending_to_customer(1)
      @variant.reload
      @variant.inventory.count_pending_to_customer.should == 100
    end
  end

  context ".subtract_pending_to_customer(num)" do
    it "updates subtract_pending_to_customer" do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 99)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.save
      @variant.subtract_pending_to_customer(1)
      @variant.reload
      @variant.inventory.count_pending_to_customer.should == 98
    end
  end

  context ".qty_to_add=(num)" do
    it "updates count_on_hand with qty_to_add" do

      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => 50)
      @variant    = create(:variant,   :inventory => inventory)
      @variant.qty_to_add = 12
      @variant.inventory.count_on_hand.should == 112
    end
  end
end
describe Variant, "instance method" do

  context ".quantity_purchaseable" do
    it 'is quantity_purchaseable' do
      inventory   = create(:inventory, :count_on_hand => 100, :count_pending_to_customer => (98))
      @variant    = create(:variant,   :inventory => inventory)
      @variant.quantity_purchaseable.should == 2 - Variant::OUT_OF_STOCK_QTY
    end    
  end
end