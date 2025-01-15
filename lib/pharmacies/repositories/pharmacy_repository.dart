import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/models/user_model.dart';
import '../models/medicine_model.dart';
import '../models/pharmacy_model.dart';
import '../providers/pharmacies_laravel_provider.dart';

class PharmacyRepository {
  late PharmaciesLaravelApiClient _laravelApiClient;

  PharmacyRepository() {
    this._laravelApiClient = Get.find<PharmaciesLaravelApiClient>();
  }

  Future<Pharmacy> get(String? storeId) {
    return _laravelApiClient.getPharmacy(storeId);
  }
  Future<List<Pharmacy>> getNearPharmacies(LatLng latLng, LatLng areaLatLng) {
    return _laravelApiClient.getNearPharmacies(latLng, areaLatLng);
  }

  Future<List<Medicine>> getMedicines(String? storeId, {int page = 1}) {
    return _laravelApiClient.getPharmacyMedicines(storeId, page);
  }

  Future<List<User>> getEmployees(String storeId) {
    return _laravelApiClient.getPharmacyEmployees(storeId);
  }

  Future<List<Medicine>> getPopularMedicines(String? storeId, {int page = 1}) {
    return _laravelApiClient.getPharmacyPopularMedicines(storeId, page);
  }

  Future<List<Medicine>> getMostRatedMedicines(String? storeId, {int page = 1}) {
    return _laravelApiClient.getPharmacyMostRatedMedicines(storeId, page);
  }

  Future<List<Medicine>> getAvailableMedicines(String? storeId, {int page = 1}) {
    return _laravelApiClient.getPharmacyAvailableMedicines(storeId, page);
  }

  Future<List<Medicine>> getFeaturedMedicines(String? storeId, {int page = 1}) {
    return _laravelApiClient.getPharmacyFeaturedMedicines(storeId, page);
  }
}
