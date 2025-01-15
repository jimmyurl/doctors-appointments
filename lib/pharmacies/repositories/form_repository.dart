import 'package:get/get.dart';

import '../models/form_model.dart' as form_model;
import '../providers/pharmacies_laravel_provider.dart';

class FormRepository {
  late PharmaciesLaravelApiClient _laravelApiClient;

  FormRepository() {
    this._laravelApiClient = Get.find<PharmaciesLaravelApiClient>();
  }

  Future<List<form_model.Form>> getAll() {
    return _laravelApiClient.getAllForms();
  }

  Future<List<form_model.Form>> getFeatured() {
    return _laravelApiClient.getFeaturedForms();
  }
}
