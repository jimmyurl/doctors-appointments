import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/block_button_widget.dart';
import '../../../../app/services/global_service.dart';
import '../../../routes/routes.dart';
import '../controllers/order_controller.dart';

class OrderActionsWidget extends GetView<OrderController> {
  const OrderActionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _order = controller.order;
    return Obx(() {
      if (!_order.value.status.hasData) {
        return SizedBox(height: 0);
      }
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (_order.value.payment == null)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Go to Checkout".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleLarge?.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 22)
                    ],
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () {
                    Get.toNamed(Routes.CHECKOUT, arguments: [_order.value]);
                  }),
            ),
          SizedBox(width: 10),
          if (!_order.value.cancel && _order.value.status.order < (Get.find<GlobalService>().global.value.onTheWay ?? 0) && _order.value.payment == null)
            MaterialButton(
              onPressed: () {
                controller.cancelOrder();
              },
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.hintColor.withOpacity(0.1),
              child: Text("Cancel".tr, style: Get.textTheme.bodyMedium),
              elevation: 0,
            ),
        ]).paddingSymmetric(vertical: 10, horizontal: 20),
      );
    });
  }
}
