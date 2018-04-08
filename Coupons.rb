class Coupons
  attr_accessor :code, :type, :value, :cashback_value, :start_date, :end_date, :active, :applicable_outlet_ids, :minimum_delivery_amount_after_discount, :maximum_discount
  
  def initialize(coupon)
    @id = coupon['id']
    @code = coupon['code']
    @type = coupon['type']
    @value = coupon['value']
    @cashback_value = coupon['cashback_value']
    @start_date = coupon['start_date']
    @end_date = coupon['end_date']
    @active = coupon['active']
    @applicable_outlet_ids = coupon['applicable_outlet_ids']
    @minimum_delivery_amount_after_discount = coupon['minimum_delivery_amount_after_discount']
    @maximum_discount = coupon['maximum_discount']
  end

  def applicable_in_outlet?(outlet)
    return true if @applicable_outlet_ids.empty? || @applicable_outlet_ids.include?(outlet)
  end
  
end