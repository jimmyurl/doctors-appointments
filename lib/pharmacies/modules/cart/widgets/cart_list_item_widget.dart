/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/cart_model.dart';
import '../controllers/cart_controller.dart';

class CartListItemWidget extends GetView<CartController> {
  const CartListItemWidget({
    Key? key,
    required Cart cart,
  })  : _cart = cart,
        super(key: key);

  final Cart _cart;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(_cart.toString()),
      onDismissed: (direction) {
        controller.removeFromCart(_cart);
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.red,
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "Delete".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                width: 70,
                height: 70,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _cart.medicine.firstImageThumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _cart.medicine.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _cart.options.map((e) => e.name).join(", "),
                    style: Get.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Ui.getPrice(
                    _cart.medicine.getPrice, // TODO price with options
                    style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MaterialButton(
                  onPressed: () => controller.incrementQuantity(_cart),
                  height: 30,
                  minWidth: 42,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  color: Get.theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                  child: Icon(Icons.add, color: Get.theme.primaryColor, size: 18),
                  elevation: 0,
                ),
                SizedBox(
                  child: Obx(() {
                    return Text(
                      _cart.quantity.value.toString(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall!.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary),
                      ),
                    );
                  }),
                ),
                MaterialButton(
                  height: 30,
                  minWidth: 42,
                  onPressed: () => controller.decrementQuantity(_cart),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: Get.theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                  child: Icon(Icons.remove, color: Get.theme.primaryColor, size: 18),
                  elevation: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
