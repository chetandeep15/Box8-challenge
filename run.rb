require "json"
require_relative "Order"

order = Order.new
cart = { cart_items: [{
        product_id: 1,
        quantity: 1,
        unit_cost: 100
      },
      {
        product_id: 2,
        quantity: 2,
        unit_cost: 200
      }]
    }.to_json
outlet_id = 4
coupon_code = "BOX8LOVE"
p order.order_food(cart,coupon_code,outlet_id)