import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/doctor_model.dart';
import '../../../models/patient_model.dart';
import '../../../repositories/doctor_repository.dart';
import '../../../repositories/patient_repository.dart';

class PatientController extends GetxController {
  final patient = Patient().obs;
  final heroTag = ''.obs;
  final currentSlide = 0.obs;
  final recentDoctors = <Doctor>[].obs;

  late PatientRepository _patientRepository;
  late DoctorRepository _doctorRepository;

  PatientController() {
    _patientRepository = new PatientRepository();
    _doctorRepository = new DoctorRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    patient.value = arguments['patient'] as Patient;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshPatient();
    super.onReady();
  }

  Future refreshPatient({bool showMessage = false}) async {
    await getPatient();
    await getRecentDoctors();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: (patient.value.first_name! + " " + patient.value.last_name!) + " " + "page refreshed successfully".tr));
    }

  }

  Future getPatient() async{
    try {
      patient.value = await _patientRepository.get(patient.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecentDoctors() async {
    try {
      recentDoctors.assignAll(await _doctorRepository.getRecentDoctorsOfPatient(patient.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

}