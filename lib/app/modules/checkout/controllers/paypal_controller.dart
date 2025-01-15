import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/appointment_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class PayPalController extends GetxController {
  late WebViewController webView;
  late PaymentRepository _paymentRepository;
  final url = Uri().obs;
  final progress = 0.0.obs;
  final appointment = new Appointment().obs;

  PayPalController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    appointment.value = Get.arguments['appointment'] as Appointment;
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
    url.value = _paymentRepository.getPayPalUrl(appointment.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/paypal";
    if (url.value.toString() == _doneUrl) {
      Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
        Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      }
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
