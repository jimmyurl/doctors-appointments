import 'package:get/get.dart';

import '../../../../app/models/address_model.dart';
import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../../app/repositories/setting_repository.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/settings_service.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../repositories/order_repository.dart';
import '../../../routes/routes.dart';
import '../../cart/controllers/cart_controller.dart';

class OrderConfirmationController extends GetxController {
  final orders = <Order>[].obs;
  final addresses = <Address>[].obs;
  late OrderRepository _orderRepository;
  late SettingRepository _settingRepository;

  Address get currentAddress => Get.find<SettingsService>().address.value;

  OrderConfirmationController() {
    _orderRepository = OrderRepository();
    _settingRepository = SettingRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await getAddresses();
    orders.value = Get.find<CartController>()
        .carts
        .map((_cart) => Order(
              orderAt: DateTime.now(),
              address: currentAddress,
              medicine: _cart.medicine,
              options: _cart.options,
              quantity: _cart.quantity.value,
              user: Get.find<AuthService>().user.value,
            ))
        .toList();
  }

  void createOrder() async {
    try {
      orders.forEach((element) => element.address = currentAddress);
      orders.value = await _orderRepository.add(orders);
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().carts.clear();
      }
      await Get.toNamed(Routes.CHECKOUT, arguments: orders);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
