import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import '../../../models/address_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../book_doctor/controllers/book_doctor_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';

class AddressPickerView extends StatefulWidget {
  @override
  State<AddressPickerView> createState() => _AddressPickerViewState();
}

class _AddressPickerViewState extends State<AddressPickerView> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String? selectedAddress;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedLocation = Get.find<SettingsService>().address.value.getLatLng();
  }

  Future<String?> getAddressFromLatLng(LatLng position) async {
    setState(() => isLoading = true);
    try {
      final apiKey = Get.find<SettingsService>().setting.value.googleMapsKey ?? '';
      final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${position.latitude},${position.longitude}',
          'key': apiKey,
        },
      );
      
      if (response.data['results'].isNotEmpty) {
        setState(() => isLoading = false);
        return response.data['results'][0]['formatted_address'];
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    setState(() => isLoading = false);
    return null;
  }

  void _showAddressDetails(String address) {
    Address _address = Address(address: address);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldWidget(
              labelText: "Description".tr,
              hintText: "My Home".tr,
              initialValue: _address.description,
              onChanged: (input) => _address.description = input,
              iconData: Icons.description_outlined,
              isFirst: true,
              isLast: false,
            ),
            TextFieldWidget(
              labelText: "Full Address".tr,
              hintText: "123 Street, City 136, State, Country".tr,
              initialValue: _address.address,
              onChanged: (input) => _address.address = input,
              iconData: Icons.place_outlined,
              isFirst: false,
              isLast: true,
            ),
            SizedBox(height: 20),
            BlockButtonWidget(
              onPressed: () async {
                Get.find<SettingsService>().address.update((val) {
                  val?.description = _address.description;
                  val?.address = _address.address;
                  val?.latitude = selectedLocation!.latitude;
                  val?.longitude = selectedLocation!.longitude;
                  val?.userId = Get.find<AuthService>().user.value.id;
                });
                if (Get.isRegistered<BookDoctorController>()) {
                  await Get.find<BookDoctorController>().getAddresses();
                }
                if (Get.isRegistered<RootController>()) {
                  await Get.find<RootController>().refreshPage(0);
                }
                Get.back(); // Close bottom sheet
                Get.back(); // Close map picker
              },
              color: Get.theme.colorScheme.secondary,
              text: Text(
                "Pick Here".tr,
                style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'.tr),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation ?? LatLng(0, 0),
              zoom: 15,
            ),
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (position) => selectedLocation = position.target,
            onCameraIdle: () async {
              if (selectedLocation != null) {
                final address = await getAddressFromLatLng(selectedLocation!);
                if (address != null) {
                  setState(() => selectedAddress = address);
                }
              }
            },
          ),
          Center(
            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator()),
          if (selectedAddress != null && !isLoading)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () => _showAddressDetails(selectedAddress!),
                child: Text('Select This Location'.tr),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}