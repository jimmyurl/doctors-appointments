import 'package:get/get.dart';

import '../controllers/medicine_controller.dart';

class MedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicineController>(
      () => MedicineController(),
    );
  }
}
