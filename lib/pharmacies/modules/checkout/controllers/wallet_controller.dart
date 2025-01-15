import 'package:get/get.dart';

import '../../../../app/models/payment_model.dart';
import '../../../../app/models/wallet_model.dart';
import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../../repositories/payment_repository.dart';

class WalletController extends GetxController {
  late PaymentRepository _paymentRepository;
  final payment = new Payment().obs;
  final orders = <Order>[].obs;
  final wallet = new Wallet().obs;

  WalletController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    orders.value = Get.arguments['orders'] as List<Order>;
    wallet.value = Get.arguments['wallet'] as Wallet;
    payOrder();
    super.onInit();
  }

  Future payOrder() async {
    try {
      if (await _paymentRepository.createWalletPayment(orders, wallet.value)) {
        refreshOrders();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isLoading() {
    return Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'createWalletPayment');
  }

  bool isDone() {
    return !Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'createWalletPayment');
  }

  bool isFailed() {
    return false;
  }

  void refreshOrders() {
    if (Get.isRegistered<TabBarController>(tag: 'orders')) {
      Get.find<TabBarController>(tag: 'orders').selectedId.value = "1";
    }
  }
}
