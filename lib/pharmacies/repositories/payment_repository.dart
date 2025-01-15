import 'package:get/get.dart';

import '../../app/models/payment_method_model.dart';
import '../../app/models/wallet_model.dart';
import '../../app/providers/laravel_provider.dart';
import '../models/order_model.dart';
import '../providers/pharmacies_laravel_provider.dart';

class PaymentRepository {
  late PharmaciesLaravelApiClient _pharmaciesLaravelApiClient;
  late LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _pharmaciesLaravelApiClient = Get.find<PharmaciesLaravelApiClient>();
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _pharmaciesLaravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<bool> create(List<Order> orders) {
    return _pharmaciesLaravelApiClient.createPayment(orders);
  }

  Future<bool> createWalletPayment(List<Order> orders, Wallet wallet) {
    return _pharmaciesLaravelApiClient.createWalletPayment(orders, wallet);
  }

  Uri getPayPalUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getPayPalUrl(orders);
  }

  String getRazorPayUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getRazorPayUrl(orders);
  }

  Uri getStripeUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getStripeUrl(orders);
  }

  String getPayStackUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getPayStackUrl(orders);
  }

  String getPayMongoUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getPayMongoUrl(orders);
  }

  String getFlutterWaveUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getFlutterWaveUrl(orders);
  }

  String getStripeFPXUrl(List<Order> orders) {
    return _pharmaciesLaravelApiClient.getStripeFPXUrl(orders);
  }
}
