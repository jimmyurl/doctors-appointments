import 'package:get/get.dart';

import '../models/option_group_model.dart';
import '../models/medicine_model.dart';
import '../providers/pharmacies_laravel_provider.dart';

class MedicineRepository {
  late PharmaciesLaravelApiClient _laravelApiClient;

  MedicineRepository() {
    this._laravelApiClient = Get.find<PharmaciesLaravelApiClient>();
  }

  Future<List<Medicine>> getAllWithPagination(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getAllMedicinesWithPagination(categoryId, page);
  }

  Future<List<Medicine>> search(String? keywords, List<String> categories, {int page = 1}) {
    return _laravelApiClient.searchMedicines(keywords, categories, page);
  }

  Future<List<Medicine>> getRecommended() {
    return _laravelApiClient.getRecommendedMedicines();
  }

  Future<List<Medicine>> getFeatured(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getFeaturedMedicines(categoryId, page);
  }

  Future<List<Medicine>> getPopular(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getPopularMedicines(categoryId, page);
  }

  Future<List<Medicine>> getMostRated(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getMostRatedMedicines(categoryId, page);
  }

  Future<List<Medicine>> getAvailable(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getAvailableMedicines(categoryId, page);
  }

  Future<Medicine> get(String? id) {
    return _laravelApiClient.getMedicine(id);
  }

  Future<List<OptionGroup>> getOptionGroups(String? medicineId) {
    return _laravelApiClient.getMedicineOptionGroups(medicineId);
  }
}
