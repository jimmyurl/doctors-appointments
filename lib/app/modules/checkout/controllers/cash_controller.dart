import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../models/payment_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class CashController extends GetxController {
  late PaymentRepository _paymentRepository;
  final payment = new Payment().obs;
  final appointment = new Appointment().obs;

  CashController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    appointment.value = Get.arguments['appointment'] as Appointment;
    payAppointment();
    super.onInit();
  }

  Future payAppointment() async {
    try {
      payment.value = await _paymentRepository.create(Appointment(id: appointment.value.id, payment: appointment.value.payment));
      if (payment.value.hasData) {
        refreshAppointments();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isLoading() {
    if (!payment.value.hasData) {
      return true;
    }
    return false;
  }

  bool isDone() {
    if (payment.value.hasData) {
      return true;
    }
    return false;
  }

  bool isFailed() {
    if (!payment.value.hasData) {
      return true;
    }
    return false;
  }

  void refreshAppointments() {
    Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
    if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
      Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
    }
  }
}
