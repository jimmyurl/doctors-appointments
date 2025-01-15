import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/block_button_widget.dart';
import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../../app/modules/global_widgets/text_field_widget.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/settings_service.dart';
import '../../../../common/ui.dart';
import '../controllers/order_confirmation_controller.dart';

class OrderConfirmationView extends GetView<OrderConfirmationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Confirmation".tr,
            style: context.textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(child: Text("Your Addresses".tr, style: Get.textTheme.bodyLarge)),
                      SizedBox(width: 4),
                      MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        onPressed: () {
                          Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text("New".tr, style: Get.textTheme.titleMedium),
                            Icon(
                              Icons.my_location,
                              color: Get.theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                        elevation: 0,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    if (controller.addresses.isEmpty) {
                      return TabBarLoadingWidget();
                    } else {
                      return TabBarWidget(
                        initialSelectedId: "0",
                        tag: 'addresses',
                        tabs: List.generate(controller.addresses.length, (index) {
                          final _address = controller.addresses.elementAt(index);
                          return ChipWidget(
                            tag: 'addresses',
                            text: _address.description,
                            id: index,
                            onSelected: (id) {
                              Get.find<SettingsService>().address.value = _address;
                            },
                          );
                        }),
                      );
                    }
                  }),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(controller.currentAddress.address, style: Get.textTheme.bodyMedium);
                        }),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
            TextFieldWidget(
              onChanged: (input) => controller.orders.forEach((element) {
                element.note = input;
              }),
              hintText: "Is there anything else you would like us to know?".tr,
              labelText: "Note".tr,
              iconData: Icons.description_outlined,
            ),
          ],
        ));
  }

  Widget buildBlockButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Obx(() {
        return BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Confirm & Checkout".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleLarge?.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
            ],
          ),
          color: Get.theme.colorScheme.secondary,
          onPressed: (!Get.find<SettingsService>().address.value.isUnknown())
              ? () {
                  controller.createOrder();
                }
              : null,
        ).paddingOnly(right: 20, left: 20);
      }),
    );
  }
}
