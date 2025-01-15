import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app/models/payment_method_model.dart';
import '../../../../app/models/payment_model.dart';
import '../../../../app/models/wallet_model.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../repositories/payment_repository.dart';

class CheckoutController extends GetxController {
  late PaymentRepository _paymentRepository;
  final paymentsList = <PaymentMethod>[].obs;
  final orders = <Order>[].obs;
  final walletList = <Wallet>[];
  final isLoading = true.obs;
  Rx<PaymentMethod> selectedPaymentMethod = new PaymentMethod().obs;

  CheckoutController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    orders.value = Get.arguments as List<Order>;
    await loadPaymentMethodsList();
    await loadWalletList();
    selectedPaymentMethod.value = this.paymentsList.firstWhere((element) => element.isDefault);
  }

  Future loadPaymentMethodsList() async {
    try {
      paymentsList.assignAll(await _paymentRepository.getMethods());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future loadWalletList() async {
    try {
      var _walletIndex = paymentsList.indexWhere((element) => element.route.toLowerCase() == Routes.WALLET);
      if (_walletIndex > -1) {
        // wallet payment method enabled
        // remove existing wallet method
        var _walletPaymentMethod = paymentsList.removeAt(_walletIndex);
        walletList.assignAll(await _paymentRepository.getWallets());
        // and replace it with new payment method object
        _insertWalletsPaymentMethod(_walletIndex, _walletPaymentMethod);
        paymentsList.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  void payOrder(List<Order> _orders) async {
    try {
      _orders = _orders.map((_order) => new Order(id: _order.id, payment: new Payment(paymentMethod: selectedPaymentMethod.value))).toList();
      if (selectedPaymentMethod.value.route.isNotEmpty) {
        await Get.toNamed('/pharmacies' + selectedPaymentMethod.value.route.toLowerCase(), arguments: {'orders': _orders, 'wallet': selectedPaymentMethod.value.wallet});
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.primaryColor));
    } else if (paymentMethod.wallet != null && (paymentMethod.wallet?.balance ?? 0) < this.getTotal()) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.focusColor));
    }
    return Get.textTheme.bodyMedium!;
  }

  TextStyle getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodySmall!;
  }

  Color? getColor(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  void _insertWalletsPaymentMethod(int _walletIndex, PaymentMethod _walletPaymentMethod) {
    walletList.forEach((_walletElement) {
      paymentsList.insert(
          _walletIndex,
          new PaymentMethod(
            isDefault: _walletPaymentMethod.isDefault,
            id: _walletPaymentMethod.id,
            name: _walletElement.name,
            description: _walletElement.balance.toString(),
            logo: _walletPaymentMethod.logo,
            route: _walletPaymentMethod.route,
            wallet: _walletElement,
          ));
    });
  }

  double getTaxesValue() {
    double taxes = 0;
    orders.forEach((cart) {
      taxes += cart.getTaxesValue();
    });
    return taxes;
  }

  double getSubtotal() {
    double subTotal = 0;
    orders.forEach((cart) {
      subTotal += cart.getSubtotal();
    });
    return subTotal;
  }

  double getTotal() {
    double total = 0;
    orders.forEach((cart) {
      total += cart.getTotal();
    });
    return total;
  }
}
