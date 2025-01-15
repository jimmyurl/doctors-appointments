import 'package:get/get.dart';

import '../controllers/create_patient_controller.dart';
import '../controllers/patient_controller.dart';
import '../controllers/patient_form_controller.dart';
import '../controllers/patients_controller.dart';

class PatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientController>(
      () => PatientController(),
    );
    Get.lazyPut<CreatePatientController>(
          () => CreatePatientController(),
    );
    Get.lazyPut<PatientsController>(
          () => PatientsController(),
    );
    Get.lazyPut<PatientFormController>(
          () => PatientFormController(),
    );
  }
}
