import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/medicine_model.dart';
import '../../../repositories/medicine_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class CategoryController extends GetxController {
  final category = new Category().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final medicines = <Medicine>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  late MedicineRepository _medicineRepository;
  ScrollController scrollController = ScrollController();

  CategoryController() {
    _medicineRepository = new MedicineRepository();
  }

  @override
  Future<void> onInit() async {
    category.value = Get.arguments as Category;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadMedicinesOfCategory(category.value.id, filter: selected.value);
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
    await loadMedicinesOfCategory(category.value.id, filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
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

  Future loadMedicinesOfCategory(String? categoryId, {CategoryFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Medicine> _medicines = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _medicines = await _medicineRepository.getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _medicines = await _medicineRepository.getFeatured(categoryId, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _medicines = await _medicineRepository.getPopular(categoryId, page: this.page.value);
          break;
        // case CategoryFilter.RATING:
        //   _medicines = await _medicineRepository.getMostRated(categoryId, page: this.page.value);
        //   break;
        case CategoryFilter.AVAILABILITY:
          _medicines = await _medicineRepository.getAvailable(categoryId, page: this.page.value);
          break;
        default:
          _medicines = await _medicineRepository.getAllWithPagination(categoryId, page: this.page.value);
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
