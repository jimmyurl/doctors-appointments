/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../appointments/widgets/appointment_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key? key,
    required Appointment appointment,
  })  : _appointment = appointment,
        super(key: key);

  final Appointment _appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          AppointmentRowWidget(
            description: _appointment.doctor!.name,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(_appointment.doctor!.getPrice, style: Get.textTheme.titleSmall),
            ),
            hasDivider: true,
          ),
          Column(
            children: List.generate(_appointment.taxes.length, (index) {
              var _tax = _appointment.taxes.elementAt(index);
              return AppointmentRowWidget(
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
                  hasDivider: (_appointment.taxes.length - 1) == index);
            }),
          ),
          AppointmentRowWidget(
            description: "Tax Amount".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(_appointment.getTaxesValue(), style: Get.textTheme.titleSmall),
            ),
            hasDivider: false,
          ),
          AppointmentRowWidget(
              description: "Subtotal".tr,
              child: Align(
                alignment: Alignment.centerRight,
                child: Ui.getPrice(_appointment.getSubtotal(), style: Get.textTheme.titleSmall),
              ),
              hasDivider: true),
          if ((_appointment.coupon?.discount ?? 0) > 0)
            AppointmentRowWidget(
                description: "Coupon".tr,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: [
                      Text(' - ', style: Get.textTheme.bodyLarge),
                      Ui.getPrice(_appointment.coupon?.discount, style: Get.textTheme.bodyLarge, unit: _appointment.coupon?.discountType == 'percent' ? "%" : null),
                    ],
                  ),
                ),
                hasDivider: true),
          AppointmentRowWidget(
            description: "Total Amount".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(_appointment.getTotal(), style: Get.textTheme.titleLarge),
            ),
          ),
        ],
      ),
    );
  }
}
