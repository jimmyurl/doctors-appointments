import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/block_button_widget.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/medicine_controller.dart';

class AddToCartWidget extends GetView<MedicineController> {
  const AddToCartWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                MaterialButton(
                  height: 24,
                  minWidth: 46,
                  onPressed: () => Get.find<MedicineController>().decrementQuantity(),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  color: Get.theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                  child: Icon(Icons.remove, color: Get.theme.primaryColor, size: 28),
                  elevation: 0,
                ),
                SizedBox(
                  width: 38,
                  child: Obx(() {
                    return Text(
                      controller.quantity.toString(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall!.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary),
                      ),
                    );
                  }),
                ),
                MaterialButton(
                  onPressed: () => controller.incrementQuantity(),
                  height: 24,
                  minWidth: 46,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  color: Get.theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
                  child: Icon(Icons.add, color: Get.theme.primaryColor, size: 28),
                  elevation: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: BlockButtonWidget(
                text: Container(
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    "Add to Cart".tr,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.titleLarge?.merge(
                      TextStyle(color: Get.theme.primaryColor),
                    ),
                  ),
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: () {
                  Get.find<CartController>().addToCart(controller.medicine.value, controller.quantity, controller.getCheckedOptions());
                }),
          ),
        ],
      ).paddingOnly(right: 20, left: 20),
    );
  }
}
