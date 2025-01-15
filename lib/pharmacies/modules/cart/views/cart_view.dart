import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/block_button_widget.dart';
import '../../../../app/modules/global_widgets/notifications_button_widget.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../../routes/routes.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_list_widget.dart';
import '../widgets/payment_details_widget.dart';

class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomWidget(),
      appBar: AppBar(
        title: Text(
          "Cart".tr,
          style: Get.textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => {Get.back()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<PharmaciesLaravelApiClient>().forceRefresh();
            controller.refreshCart(showMessage: true);
            Get.find<PharmaciesLaravelApiClient>().unForceRefresh();
          },
          child: CartListWidget()),
    );
  }

  Widget buildBottomWidget() {
    return Obx(() {
      if (controller.carts.isEmpty) {
        return SizedBox(height: 0);
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentDetailsWidget(),
            BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Checkout".tr,
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
                onPressed: () {
                  Get.toNamed(Routes.ORDER_CONFIRMATION);
                }).paddingSymmetric(vertical: 10, horizontal: 20),
          ],
        ),
      );
    });
  }
}
