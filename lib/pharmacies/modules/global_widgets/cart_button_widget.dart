import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/auth_service.dart';
import '../../routes/routes.dart' as pharmaciesRoutes;
import '../cart/controllers/cart_controller.dart';

class CartButtonWidget extends GetView<CartController> {
  const CartButtonWidget({
    this.iconColor,
    this.labelColor,
    Key? key,
  }) : super(key: key);

  final Color? iconColor;
  final Color? labelColor;

  Widget build(BuildContext context) {
    return MaterialButton(
      hoverElevation: 0,
      highlightElevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      minWidth: 38,
      height: 60,
      elevation: 0,
      onPressed: () async {
        if (Get.find<AuthService>().isAuth == true) {
          await controller.refreshCart();
          Get.toNamed(pharmaciesRoutes.Routes.CART);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_basket_outlined,
            color: iconColor ?? Get.theme.hintColor,
            size: 28,
          ),
          Container(
            child: Obx(() {
              return Center(
                child: Text(
                  controller.carts.length.toString(),
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodySmall!.merge(
                    TextStyle(color: Get.theme.primaryColor, fontSize: 9, height: 1.4),
                  ),
                ),
              );
            }),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: labelColor ?? Get.theme.colorScheme.secondary, borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 16, maxWidth: 16, minHeight: 16, maxHeight: 16),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
