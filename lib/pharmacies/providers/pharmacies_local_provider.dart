import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/cart_model.dart';

class PharmaciesLocalProvider extends GetxService {
  late GetStorage _box;

  PharmaciesLocalProvider() {
    _box = new GetStorage('pharmacies_local_provider');
    //_box.erase();
  }

  Future<PharmaciesLocalProvider> init() async {
    return this;
  }

  Future<List<Cart>> addToCart(Cart cart) async {
    // read the cart from the local storage
    List<Cart> _cart = _readCart();
    // check if the medicine is already in the cart
    if (_cart.contains(cart)) {
      _cart[_cart.indexOf(cart)].quantity.value += cart.quantity.value;
    } else {
      _cart.add(cart);
    }
    // save the cart to the local storage
    _writeCart(_cart);
    return _cart;
  }

  Future<List<Cart>> removeFromCart(Cart cart) async {
    // read the cart from the local storage
    List<Cart> _cart = _readCart();
    // remove the medicine from the cart
    _cart.removeWhere((e) => e == cart);
    // save the cart to the local storage
    _writeCart(_cart);
    return _cart;
  }

  Future<List<Cart>> updateCart(List<Cart> cart) async {
    // save the new cart to the local storage
    _writeCart(cart);
    return cart;
  }

  void _writeCart(List<Cart> cart) {
    // save the cart to the local storage as json
    _box.write('cart', jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  Future<List<Cart>> getCart() {
    // read the cart from the local storage
    List<Cart> _cart = _readCart();
    return Future.value(_cart);
  }

  List<Cart> _readCart() {
    List<Cart> _cart = <Cart>[];
    print(_box.read('cart'));
    if (_box.read('cart') != null && _box.read('cart').length > 0) {
      var _json = jsonDecode(_box.read('cart'));
      _cart = _json.map((e) => Cart.fromJson(e)).toList();
    }
    return _cart;
  }
}
