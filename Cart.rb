class Cart
  attr_accessor :product_id, :quantity, :unit_cost, :product_total

  def initialize(cart_item)
    @product_id = cart_item['product_id']
    @quantity = cart_item['quantity']
    @unit_cost = cart_item['unit_cost']
    calculate_product_total
  end
  
  def calculate_product_total
    @product_total = @quantity*@unit_cost
  end
end