import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/medicine_model.dart';
import '../../../models/pharmacy_model.dart';
import '../../../repositories/pharmacy_repository.dart';

class PharmacyController extends GetxController {
  final pharmacy = Pharmacy().obs;
  final featuredMedicines = <Medicine>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  late PharmacyRepository _storeRepository;

  PharmacyController() {
    _storeRepository = new PharmacyRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    pharmacy.value = arguments['pharmacy'] as Pharmacy;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshPharmacy();
    super.onReady();
  }

  Future refreshPharmacy({bool showMessage = false}) async {
    await getPharmacy();
    await getFeaturedMedicines();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: pharmacy.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getPharmacy() async {
    try {
      pharmacy.value = await _storeRepository.get(pharmacy.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedMedicines() async {
    try {
      featuredMedicines.assignAll(await _storeRepository.getFeaturedMedicines(pharmacy.value.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
