module Discount
  
  def calculate_discount(coupon,cart)
    case coupon.type  
    when "Percentage"
      calculate_percentage_discount(coupon,cart)
    when "Discount"
      calculate_normal_discount(coupon,cart)
    when "Discount&Cashback"
      calculate_discount_and_cashback(coupon,cart)
    when "Percentage&Cashback"
      calculate_percentage_and_cashback(coupon,cart)
    when "Bogo"
      calculate_bogo_discount(coupon,cart)
    end
  end

  def calculate_cart_total(cart)
    cart_total = cart.inject(0) { |sum,x| sum+x.product_total } 
  end

  def calculate_percentage_discount(coupon,cart)
     final_cashback = 0 
     final_discount = 0
     cart_total = calculate_cart_total(cart)
     calculated_discount = (cart_total*coupon.value)/100
     final_discount = [calculated_discount, coupon.maximum_discount].min
     final_total = cart_total - final_discount
     if final_total > coupon.minimum_delivery_amount_after_discount
       return [final_discount,final_cashback,"Coupon Applied"]
     else
       final_discount = 0
       return [final_discount,final_cashback,"Coupon Cannot be applied, amount after discount is less than minimum delivery amount."]
     end
  end

  def calculate_normal_discount(coupon,cart)
    final_cashback = 0 
    final_discount = 0
    cart_total = calculate_cart_total(cart)
    final_total = cart_total-coupon.value
    if final_total < 0
      return [final_discount,final_cashback,"Coupon cannot be applied, cart total less than discount value"]
    elsif final_total < coupon.minimum_delivery_amount_after_discount
      return [final_discount,final_cashback,"Coupon Cannot be applied, amount after discount is less than minimum delivery amount."]
    else
      final_discount = coupon.value
      return [final_discount,final_cashback,"Coupon Applied"]
    end
  end

  def calculate_cashback(coupon,cart)
    final_cashback = 0
    cart_total = calculate_cart_total(cart)
    final_total = cart_total-coupon.cashback_value
    if final_total < 0
      return [final_cashback,"Coupon cannot be applied, cart total less than cashback value"]
    elsif final_total < coupon.minimum_delivery_amount_after_discount
      return [final_cashback,"Coupon Cannot be applied, amount after cashback is less than minimum delivery amount."]
    else
      final_discount = coupon.cashback_value
      return [final_discount,final_cashback,"Coupon Applied"]
    end    

  end

  def calculate_discount_and_cashback(coupon,cart)
    final_discount = calculate_normal_discount(coupon,cart)
    final_cashback = calculate_cashback(coupon,cart)
    if final_discount[-1] != "Coupon Applied"
      final_discount = 0
      final_cashback = 0 
      return [final_discount,final_cashback,final_discount[-1]]
    elsif final_cashback[-1] != "Coupon Applied"
      final_discount = 0
      final_cashback = 0 
      return [final_discount,final_cashback,final_cashback[-1]]
    else
      return [final_discount,final_cashback,"Coupon Applied"]
    end
  end

  def calculate_percentage_and_cashback(coupon,cart)
    final_discount = calculate_percentage_discount(coupon_cart)
    final_cashback = calculate_cashback(coupon,cart)
    if final_discount[-1] != "Coupon Applied"
      final_discount = 0
      final_cashback = 0 
      return [final_discount,final_cashback,final_discount[-1]]
    elsif final_cashback[-1] != "Coupon Applied"
      final_discount = 0
      final_cashback = 0 
      return [final_discount,final_cashback,final_cashback[-1]]
    else
      return [final_discount,final_cashback,"Coupon Applied"]
    end
  end

  def calculate_bogo_discount(coupon,cart)
    final_discount = 0
    final_cashback = 0
    cart_total = calculate_cart_total(cart)
    total_cart_length = cart.inject(0) {|sum,x| sum+x.quantity}
    if total_cart_length < 2
      return [final_discount,final_cashback, "Coupon cannot be applied not enough items in the cart."]
    else
      bogo_items_length = total_cart_length / 2
      cart.sort_by! { |c| c.unit_price  }
      bogo_cart = Array.new
      cart.each do |cart_item|
        if bogo_items_length-cart_item.quantity>=0
          bogo_cart<<cart_item
        elsif bogo_items_length-cart_item.quantity < 0 && bogo_items_length > 0
          cart_item.quantity -= bogo_items_length
          cart_item.product_total = cart_item * cart_item.quantity
          bogo_cart<<cart_item
        else
          break;
        end
        bogo_items_length -= cart_item.quantity
      end
      bogo_discount = calculate_cart_total(bogo_cart)
      final_discount = [bogo_discount, coupon.maximum_discount].min
      final_total = cart_total - final_discount
      if final_total > coupon.minimum_delivery_amount_after_discount
        return [final_discount,final_cashback,"Coupon Applied"]
      else
        final_discount = 0
        return [final_discount,final_cashback,"Coupon Cannot be applied, amount after discount is less than minimum delivery amount."]
      end
    end
  end
end