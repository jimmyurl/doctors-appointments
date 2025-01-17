import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

import '../../../models/address_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../book_doctor/controllers/book_doctor_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';

class AddressPickerView extends StatelessWidget {
  AddressPickerView();

  @override
  Widget build(BuildContext context) {
    return MapLocationPicker(
      apiKey: Get.find<SettingsService>().setting.value.googleMapsKey ?? '',
      currentLatLng: Get.find<SettingsService>().address.value.getLatLng(),
      mapType: MapType.normal,
      onNext: (GeocodingResult? result) {
        if (result != null) {
          Address _address = Address(address: result.formattedAddress ?? '');
          
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
                        val?.latitude = result.geometry.location.lat;
                        val?.longitude = result.geometry.location.lng;
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
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        }
      },
      onSuggestionSelected: (PlacesDetailsResponse? result) {
        // Handle place suggestion selection if needed
      },
    );
  }
}