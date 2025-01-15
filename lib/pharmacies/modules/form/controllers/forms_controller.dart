import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/form_model.dart' as form_model;
import '../../../repositories/form_repository.dart';

enum FormsLayout { GRID, LIST }

class FormsController extends GetxController {
  late FormRepository _formRepository;

  final forms = <form_model.Form>[].obs;
  final layout = FormsLayout.LIST.obs;

  FormsController() {
    _formRepository = new FormRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshForms();
    super.onInit();
  }

  Future refreshForms({bool? showMessage}) async {
    await getForms();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of forms refreshed successfully".tr));
    }
  }

  Future getForms() async {
    try {
      forms.assignAll(await _formRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
