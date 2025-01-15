/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/medicine_model.dart';
import '../../../routes/routes.dart';

class MedicinesListItemWidget extends StatelessWidget {
  const MedicinesListItemWidget({
    Key? key,
    required Medicine medicine,
  })  : _medicine = medicine,
        super(key: key);

  final Medicine _medicine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.MEDICINE, arguments: {'medicine': _medicine, 'heroTag': 'store_medicines_list_item'});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          //alignment: AlignmentDirectional.topStart,
          children: [
            Hero(
              tag: 'store_medicines_list_item' + _medicine.id,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: _medicine.firstImageUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _medicine.name,
                    maxLines: 2,
                    style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.hintColor)),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 5,
                    alignment: WrapAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        "Start from".tr,
                        style: Get.textTheme.bodySmall,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_medicine.getOldPrice > 0)
                            Ui.getPrice(
                              _medicine.getOldPrice,
                              style: Get.textTheme.bodyLarge!.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                              unit: _medicine.quantityUnit,
                            ),
                          Ui.getPrice(
                            _medicine.getPrice,
                            style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                            unit: _medicine.quantityUnit,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
