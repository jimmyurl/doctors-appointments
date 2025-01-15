import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/medicine_model.dart';
import '../../../repositories/medicine_repository.dart';

class MedicineController extends GetxController {
  final medicine = Medicine().obs;
  final optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final Rx<int> quantity = 1.obs;
  final heroTag = ''.obs;
  late MedicineRepository _medicineRepository;

  MedicineController() {
    _medicineRepository = new MedicineRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    medicine.value = arguments['medicine'] as Medicine;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshMedicine();
    super.onReady();
  }

  Future refreshMedicine({bool showMessage = false}) async {
    await getMedicine();
    await getOptionGroups();
    quantity.value = 1;
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: medicine.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getMedicine() async {
    try {
      medicine.value = await _medicineRepository.get(medicine.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getOptionGroups() async {
    try {
      var _optionGroups = await _medicineRepository.getOptionGroups(medicine.value.id);
      optionGroups.assignAll(_optionGroups.map((element) {
        element.options.removeWhere((option) => option.medicineId != medicine.value.id);
        return element;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectOption(OptionGroup optionGroup, Option option) {
    optionGroup.options.forEach((e) {
      if (!optionGroup.allowMultiple && option != e) {
        e.checked.value = false;
      }
    });
    option.checked.value = !option.checked.value;
  }

  List<Option> getCheckedOptions() {
    if (optionGroups.isNotEmpty) {
      return optionGroups.map((element) => element.options).expand((element) => element).toList().where((option) => option.checked.value).toList();
    }
    return [];
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyMedium!;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodySmall!;
  }

  Color? getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
  }
}
