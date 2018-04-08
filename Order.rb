require "open-uri"
require "json"
require_relative "Discount"
require_relative "Coupons"
require_relative "Cart"

class Order
  include Discount

  URL = "https://gist.githubusercontent.com/mntdamania/9a74afefbbc7e853fb84146d3c81676d/raw/0ae8aa2846dcf1fadb02dc605126e9ea3b8676ae/coupon_codes.json"
  def initialize
    save_json
    @coupons = Array.new
    @cart = Array.new
    @final_message = {valid: false ,message: "", discount: 0, cashback: 0}
  end

  def order_food(cart_items,coupon_code,outlet_id)
    @cart_items = JSON.parse(cart_items)
    get_coupons
    set_coupons
    set_cart
    apply_coupon(coupon_code,outlet_id)
  end

  def set_cart
    @cart_items['cart_items'].each do |item|
      @cart<<Cart.new(item)
    end
  end

  def set_coupons
    @coupon_data['coupon_codes'].each do |coupon|
      @coupons<<Coupons.new(coupon)
    end
  end

  def apply_coupon(coupon_code,outlet_id)
    coupon = 0
    @coupons.each {|c| coupon = c if c.code == coupon_code}
    if coupon.applicable_in_outlet?(outlet_id)
      final_price(coupon)
    else
      @final_message[:message] = "Coupon cannot be applied to the outlet"
    end
  end

  def final_price(coupon)
    if !coupon.active
      @final_message[:message] = "Coupon not active"
    else
      discount,cashback, message = calculate_discount(coupon,@cart)
      if message != "Coupon Applied"
        @final_message = {valid: false ,message: message, discount: discount, cashback: cashback}
      else
        @final_message = {valid: true ,message: message, discount: discount, cashback: cashback}
      end
    end
    @final_message.to_json
  end

  private

  def save_json
    @response=open(URL).read
    File.write('coupons.json',@response)
  end

  def get_coupons
    file=File.read('coupons.json')
    @coupon_data = JSON.parse(file)
  end
end