import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../../repositories/payment_repository.dart';

class CashController extends GetxController {
  late PaymentRepository _paymentRepository;
  final orders = <Order>[].obs;

  CashController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    orders.value = Get.arguments['orders'] as List<Order>;
    payOrder();
    super.onInit();
  }

  Future payOrder() async {
    try {
      if (await _paymentRepository.create(orders)) {
        refreshOrders();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isLoading() {
    return Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'createPayment');
  }

  bool isDone() {
    return !Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'createPayment');
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
