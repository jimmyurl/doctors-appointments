import 'package:get/get.dart';

import '../controllers/medicines_controller.dart';
import '../controllers/store_controller.dart';

class PharmacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyController>(
      () => PharmacyController(),
    );
    Get.lazyPut<MedicinesController>(
      () => MedicinesController(),
    );
  }
}
