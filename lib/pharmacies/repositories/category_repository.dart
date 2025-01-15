import 'package:get/get.dart';

import '../models/category_model.dart';
import '../providers/pharmacies_laravel_provider.dart';

class CategoryRepository {
  late PharmaciesLaravelApiClient _laravelApiClient;

  CategoryRepository() {
    this._laravelApiClient = Get.find<PharmaciesLaravelApiClient>();
  }

  Future<List<Category>> getAll() {
    return _laravelApiClient.getAllCategories();
  }

  Future<List<Category>> getAllParents() {
    return _laravelApiClient.getAllParentCategories();
  }

  Future<List<Category>> getAllWithSubCategories() {
    return _laravelApiClient.getAllWithSubCategories();
  }

  Future<List<Category>> getSubCategories(String? categoryId) {
    return _laravelApiClient.getSubCategories(categoryId);
  }

  Future<List<Category>> getFeatured() {
    return _laravelApiClient.getFeaturedCategories();
  }
}
