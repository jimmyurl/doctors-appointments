import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/services/global_service.dart';
import '../../../models/order_model.dart';
import '../../../routes/routes.dart';
import '../controllers/orders_controller.dart';

class OrderOptionsPopupMenuWidget extends GetView<OrdersController> {
  const OrderOptionsPopupMenuWidget({
    Key? key,
    required Order order,
  })  : _order = order,
        super(key: key);

  final Order _order;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) {
        switch (item) {
          case "cancel":
            {
              controller.cancelOrder(_order);
            }
            break;
          case "view":
            {
              Get.toNamed(Routes.ORDER, arguments: _order);
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "ID #".tr + _order.id,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "View Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        if (!_order.cancel && _order.status.order < (Get.find<GlobalService>().global.value.onTheWay ?? 0)) {
          list.add(PopupMenuDivider(
            height: 10,
          ));
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  Text(
                    "Cancel".tr,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              value: "cancel",
            ),
          );
        }
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }
}
