import 'package:get/get.dart';

import '../controllers/forms_controller.dart';
import '../controllers/form_controller.dart';

class FormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormController>(
      () => FormController(),
    );
    Get.lazyPut<FormsController>(
      () => FormsController(),
    );
  }
}
