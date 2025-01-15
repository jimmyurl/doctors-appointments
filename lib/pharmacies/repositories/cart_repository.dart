import 'package:get/get.dart';

import '../models/cart_model.dart';
import '../providers/pharmacies_laravel_provider.dart';

class CartRepository {
  late PharmaciesLaravelApiClient _pharmaciesLaravelApiClient;

  CartRepository() {
    this._pharmaciesLaravelApiClient = Get.find<PharmaciesLaravelApiClient>();
  }

  Future<List<Cart>> getCart() {
    return _pharmaciesLaravelApiClient.getCart();
  }

  Future<Cart> addToCart(Cart cart) {
    return _pharmaciesLaravelApiClient.addToCart(cart);
  }

  Future<Cart> removeFromCart(Cart cart) {
    return _pharmaciesLaravelApiClient.removeFromCart(cart);
  }

  Future<Cart> updateCart(Cart cart) {
    return _pharmaciesLaravelApiClient.updateCart(cart);
  }
}
