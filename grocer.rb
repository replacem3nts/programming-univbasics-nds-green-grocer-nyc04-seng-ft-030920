require 'pp'

# this method searches a collection (AoH) and 
# if name matches value of ":item" returns the hash

def find_item_by_name_in_collection(name, collection)
    i = 0
    while i < collection.length do
      item_hash = collection[i]
      item_hash[:item] == name ? (return item_hash) : nil
      i += 1
    end
end

def consolidate_cart(cart)
  new_cart = [{:item => nil}]
  i = 0
  while i < cart.length do
    cart_hash = cart[i]
    if !find_item_by_name_in_collection(cart_hash[:item], new_cart)
      new_cart << cart_hash
      new_cart.last[:count] = 1
    else
      n = 0
      while n < new_cart.length do
        if new_cart[n][:item] == cart_hash[:item]
          new_cart[n][:count] += 1
        end
        n += 1
      end
    end
    i += 1
  end
  new_cart.shift
  new_cart
end


def new_coupon(coupon_hash, cart_hash)
  coupon = {:item => "#{cart_hash[:item]} W/COUPON", :price => (coupon_hash[:cost] / coupon_hash[:num]), :clearance => cart_hash[:clearance], :count => (cart_hash[:count] - (cart_hash[:count] % coupon_hash[:num]))}
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.count do
    coupon_hash = coupons[i]
    n = 0
    while n < cart.length do
      cart_hash = cart[n]
      if (coupon_hash[:item] == cart_hash[:item]) && (cart_hash[:count] >= coupon_hash[:num])
          cart << new_coupon(coupon_hash, cart_hash)
          cart_hash[:count] = (cart_hash[:count] - cart.last[:count])
      end
      n += 1
    end
  i += 1
  end
  cart
end

def apply_clearance(cart)
  i = 0
  discount = 0.2
  while i < cart.length do
    cart_hash = cart[i]
    if cart_hash[:clearance] == true
      cart_hash[:price] = (cart_hash[:price] * (1 - discount)).round(1)
    end
    i += 1
  end
  cart
end

def run_total(cart)
  subtotal = 0
  i = 0
  while i < cart.length do
    item_price = cart[i][:price]
    item_no = cart[i][:count]
    subtotal += (item_price * item_no)
    i += 1
  end
  subtotal
end

def checkout(cart, coupons)
  subtotal = 0
  cons_cart = consolidate_cart(cart)
  subtotal = run_total(cons_cart)
  
  if coupons.length != 0
    coup_cart = apply_coupons(cons_cart, coupons)
    subtotal = run_total(coup_cart)
  else
    coup_cart = cons_cart
  end

  clear_cart = apply_clearance(coup_cart)  
  big_spend_disc = 0.1
  if run_total(clear_cart) > 100
    subtotal = (run_total(clear_cart) * (1 - big_spend_disc)).round(1)
  else
    subtotal = run_total(clear_cart)
  end
  
  subtotal
end
