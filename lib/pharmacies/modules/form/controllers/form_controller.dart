import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/form_model.dart' as form_model;
import '../../../models/medicine_model.dart';
import '../../../repositories/medicine_repository.dart';

enum FormFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class FormController extends GetxController {
  final form = new form_model.Form().obs;
  final selected = Rx<FormFilter>(FormFilter.ALL);
  final medicines = <Medicine>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  late MedicineRepository _medicineRepository;
  ScrollController scrollController = ScrollController();

  FormController() {
    _medicineRepository = new MedicineRepository();
  }

  @override
  Future<void> onInit() async {
    form.value = Get.arguments as form_model.Form;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadMedicinesOfForm(form.value.id, filter: selected.value);
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
    await loadMedicinesOfForm(form.value.id, filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(FormFilter filter) => selected == filter;

  void toggleSelected(FormFilter filter) {
    this.medicines.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = FormFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadMedicinesOfForm(String? formId, {FormFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Medicine> _medicines = [];
      switch (filter) {
        case FormFilter.ALL:
          _medicines = await _medicineRepository.getAllWithPagination(formId, page: this.page.value);
          break;
        case FormFilter.FEATURED:
          _medicines = await _medicineRepository.getFeatured(formId, page: this.page.value);
          break;
        case FormFilter.POPULAR:
          _medicines = await _medicineRepository.getPopular(formId, page: this.page.value);
          break;
        // case FormFilter.RATING:
        //   _medicines = await _medicineRepository.getMostRated(formId, page: this.page.value);
        //   break;
        case FormFilter.AVAILABILITY:
          _medicines = await _medicineRepository.getAvailable(formId, page: this.page.value);
          break;
        default:
          _medicines = await _medicineRepository.getAllWithPagination(formId, page: this.page.value);
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
