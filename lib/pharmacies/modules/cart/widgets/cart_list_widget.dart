import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/pharmacies_laravel_provider.dart';
import '../controllers/cart_controller.dart';
import 'cart_empty_list_widget.dart';
import 'cart_list_item_widget.dart';
import 'cart_list_loader_widget.dart';

class CartListWidget extends GetView<CartController> {
  CartListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'getCart')) {
        return CartListLoaderWidget();
      } else if (controller.carts.isEmpty) {
        return CartEmptyListWidget();
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: true,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: controller.carts.length,
          itemBuilder: ((_, index) {
            var _cart = controller.carts.elementAt(index);
            return CartListItemWidget(cart: _cart);
          }),
        );
      }
    });
  }
}
