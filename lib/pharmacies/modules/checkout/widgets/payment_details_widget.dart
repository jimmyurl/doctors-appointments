/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../orders/widgets/order_row_widget.dart';
import '../controllers/checkout_controller.dart';

class PaymentDetailsWidget extends GetView<CheckoutController> {
  const PaymentDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
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
