import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../../app/services/global_service.dart';
import '../../../../common/helper.dart';
import '../../../models/order_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/routes.dart';
import '../../orders/controllers/orders_controller.dart';

class PayPalController extends GetxController {
  late WebViewController webView;
  late PaymentRepository _paymentRepository;
  final url = Uri().obs;
  final progress = 0.0.obs;
  final orders = <Order>[].obs;

  PayPalController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    orders.value = Get.arguments['orders'] as List<Order>;
    getUrl();
    initWebView();
    super.onInit();
  }

  void initWebView() {
    webView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url.value)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String _url) {
            url.value = Uri.parse(_url);
            showConfirmationIfSuccess();
          },
          onPageFinished: (String url) {
            progress.value = 1;
          },
        ),
      );
  }

  void getUrl() {
    url.value = _paymentRepository.getPayPalUrl(orders);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}pharmacies/payments/paypal";
    if (url.value.toString() == _doneUrl) {
      if (Get.isRegistered<OrdersController>()) {
        Get.find<OrdersController>().currentStatus.value = Get.find<OrdersController>().getStatusByOrder(50).id;
      }
      if (Get.isRegistered<TabBarController>(tag: 'orders')) {
        Get.find<TabBarController>(tag: 'orders').selectedId.value = "1";
      }
      Get.toNamed(Routes.PAYMENT_CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
