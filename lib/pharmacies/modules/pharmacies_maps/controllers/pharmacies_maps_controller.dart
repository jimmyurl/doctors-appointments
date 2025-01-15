/*
 * File name: pharmacies_maps_controller.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/models/address_model.dart';
import '../../../../app/services/settings_service.dart';
import '../../../../common/ui.dart';
import '../../../models/pharmacy_model.dart';
import '../../../repositories/pharmacy_repository.dart';


class PharmaciesMapsController extends GetxController {
  final pharmacies = <Pharmacy>[].obs;
  final allMarkers = <Marker>[].obs;
  final cameraPosition = new CameraPosition(target: LatLng(0, 0)).obs;
  final mapController = Rx<GoogleMapController?>(null);
  late PharmacyRepository _pharmacyRepository;

  PharmaciesMapsController() {
    _pharmacyRepository = new PharmacyRepository();
  }

  Address get currentAddress => Get.find<SettingsService>().address.value;

  @override
  void onInit() async {
    await refreshMaps();
    super.onInit();
  }

  Future refreshMaps({bool showMessage = false}) async {
    await getCurrentPosition();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Future<void> getCurrentPosition() async {
    cameraPosition.value = CameraPosition(
      target: currentAddress.getLatLng(),
      zoom: 14.4746,
    );
    Marker marker = await _getMyPositionMarker(currentAddress.getLatLng());
    allMarkers.add(marker);
  }

  Future getNearPharmacies() async {
    try {
      pharmacies.clear();
      pharmacies.assignAll(await _pharmacyRepository.getNearPharmacies(currentAddress.getLatLng(), cameraPosition.value.target));
      print(pharmacies.length);
      pharmacies.forEach((element) async {
        var pharmacyMarket = await getPharmacyMarker(element);
        allMarkers.add(pharmacyMarket);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Marker> _getMyPositionMarker(LatLng latLng) async {
    final Uint8List markerIcon = await _getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(markerId: MarkerId(Random().nextInt(100).toString()), icon: BitmapDescriptor.fromBytes(markerIcon), anchor: ui.Offset(0.5, 0.5), position: latLng);

    return marker;
  }

  Future<Marker> getPharmacyMarker(Pharmacy pharmacy) async {
    final Uint8List markerIcon = await _getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
      markerId: MarkerId(pharmacy.id),
      icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
      anchor: ui.Offset(0.5, 0.5),
      infoWindow: InfoWindow(
          title: pharmacy.name,
          snippet: Ui.getDistance(0.0),
          onTap: () {
            //print(CustomTrace(StackTrace.current, message: 'Info Window'));
          }),
      position: pharmacy.addresses.first.getLatLng()
      // TODO FIX ADDRESSES
    );

    return marker;
  }
}
