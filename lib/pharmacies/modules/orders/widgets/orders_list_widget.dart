import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/pharmacies_laravel_provider.dart';
import '../controllers/orders_controller.dart';
import 'orders_empty_list_widget.dart';
import 'orders_list_item_widget.dart';
import 'orders_list_loader_widget.dart';

class OrdersListWidget extends GetView<OrdersController> {
  OrdersListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'getOrders') && controller.page.value == 1) {
        return OrdersListLoaderWidget();
      } else if (controller.orders.isEmpty) {
        return OrdersEmptyListWidget();
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.orders.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.orders.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _order = controller.orders.elementAt(index);
              return OrdersListItemWidget(order: _order);
            }
          }),
        );
      }
    });
  }
}
