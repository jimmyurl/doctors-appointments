import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/medicine_model.dart';
import '../../../models/pharmacy_model.dart';
import '../../../repositories/pharmacy_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class MedicinesController extends GetxController {
  final pharmacy = new Pharmacy().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final medicines = <Medicine>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  late PharmacyRepository _storeRepository;
  ScrollController scrollController = ScrollController();

  MedicinesController() {
    _storeRepository = new PharmacyRepository();
  }

  @override
  Future<void> onInit() async {
    pharmacy.value = Get.arguments as Pharmacy;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadMedicinesOfCategory(filter: selected.value);
      }
    });
    await refreshMedicines();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshMedicines({bool? showMessage}) async {
    toggleSelected(selected.value);
    await loadMedicinesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of medicines refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.medicines.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadMedicinesOfCategory({CategoryFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Medicine> _medicines = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _medicines = await _storeRepository.getMedicines(pharmacy.value.id, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _medicines = await _storeRepository.getFeaturedMedicines(pharmacy.value.id, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _medicines = await _storeRepository.getPopularMedicines(pharmacy.value.id, page: this.page.value);
          break;
/*        case CategoryFilter.RATING:
          _medicines = await _storeRepository.getMostRatedMedicines(pharmacy.value.id, page: this.page.value);
          break;*/
        case CategoryFilter.AVAILABILITY:
          _medicines = await _storeRepository.getAvailableMedicines(pharmacy.value.id, page: this.page.value);
          break;
        default:
          _medicines = await _storeRepository.getMedicines(pharmacy.value.id, page: this.page.value);
      }
      if (_medicines.isNotEmpty) {
        this.medicines.addAll(_medicines);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
