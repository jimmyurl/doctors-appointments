/*
 * File name: pharmacies_maps_view.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/pharmacies_maps_controller.dart';
import '../widgets/pharmacies_maps_carousel_widget.dart';

class PharmaciesMapsView extends GetView<PharmaciesMapsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Obx(() {
            return GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              myLocationEnabled: true,
              padding: EdgeInsets.only(top: 35),
              mapType: MapType.normal,
              initialCameraPosition: controller.cameraPosition.value,
              markers: Set.from(controller.allMarkers),
              onMapCreated: (GoogleMapController _controller) {
                controller.mapController.value = _controller;
              },
              onCameraMoveStarted: () {
                controller.pharmacies.clear();
              },
              onCameraMove: (CameraPosition cameraPosition) {
                controller.cameraPosition.value = cameraPosition;
              },
              onCameraIdle: () {
                controller.getNearPharmacies();
              },
            );
          }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PharmaciesMapsCarouselWidget(),
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: 50),
            height: 120,
            child: Row(
              children: [
                new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: Text(
                    "Maps Explorer".tr,
                    style: Get.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
