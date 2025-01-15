/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../orders/widgets/order_row_widget.dart';
import '../controllers/cart_controller.dart';

class PaymentDetailsWidget extends GetView<CartController> {
  const PaymentDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
/*          Column(
            children: List.generate(_order.options?.length, (index) {
              var _option = _order.options.elementAt(index);
              return OrderRowWidget(
                  description: _option.name,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_option.price, style: Get.textTheme.bodyLarge),
                  ),
                  hasDivider: (_order.options.length - 1) == index);
            }),
          ),*/
/*          OrderRowWidget(
              description: "Quantity".tr,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "x" + _cart.quantity.toString() + " " + _cart.medicine.quantityUnit,
                  style: Get.textTheme.bodyMedium,
                ),
              ),
              hasDivider: true),*/
/*          Column(
            children: List.generate(_order.taxes.length, (index) {
              var _tax = _order.taxes.elementAt(index);
              return OrderRowWidget(
                  description: _tax.name,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _tax.type == 'percent'
                        ? Text(_tax.value.toString() + '%', style: Get.textTheme.bodyLarge)
                        : Ui.getPrice(
                            _tax.value,
                            style: Get.textTheme.bodyLarge,
                          ),
                  ),
                  hasDivider: (_order.taxes.length - 1) == index);
            }),
          ),*/
          OrderRowWidget(
            description: "Tax Amount".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(controller.getTaxesValue(), style: Get.textTheme.titleSmall),
            ),
            hasDivider: false,
          ),
          OrderRowWidget(
              description: "Subtotal".tr,
              child: Align(
                alignment: Alignment.centerRight,
                child: Ui.getPrice(controller.getSubtotal(), style: Get.textTheme.titleSmall),
              ),
              hasDivider: true),
          OrderRowWidget(
            description: "Total Amount".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(controller.getTotal(), style: Get.textTheme.titleLarge),
            ),
          ),
        ],
      ),
    );
  }
}
