/*
 * File name: pharmacies_maps_binding.dart
 * Last modified: 2022.02.10 at 22:29:48
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../controllers/pharmacies_maps_controller.dart';

class PharmaciesMapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmaciesMapsController>(
      () => PharmaciesMapsController(),
    );
  }
}
