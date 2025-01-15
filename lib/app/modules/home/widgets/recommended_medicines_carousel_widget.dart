import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../../pharmacies/routes/routes.dart';
import '../../../services/settings_service.dart';
import '../controllers/home_controller.dart';

class RecommendedMedicinesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!Get.find<SettingsService>().isModuleActivated("Pharmacies")) {
        return SizedBox();
      } else {
        return Column(
          children: [
            Container(
              color: Get.theme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Expanded(child: Text("Recommended Medicines".tr, style: Get.textTheme.headlineSmall)),
                  MaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.CATEGORIES);
                    },
                    shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    child: Text("View All".tr, style: Get.textTheme.titleMedium),
                    elevation: 0,
                  ),
                ],
              ),
            ),
            Container(
              height: 280,
              color: Get.theme.primaryColor,
              child: Obx(() {
                return ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.medicines.length,
                    itemBuilder: (_, index) {
                      var _medicine = controller.medicines.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.MEDICINE, arguments: {'medicine': _medicine, 'heroTag': 'medicines_list_item'});
                        },
                        child: Container(
                          width: 180,
                          margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                tag: 'recommended_medicine_carousel' + _medicine.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    height: 150,
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
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _medicine.name,
                                          maxLines: 2,
                                          style: Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.hintColor)),
                                        ),
                                        if (_medicine.stockQuantity < 10)
                                          Wrap(
                                            children: [
                                              SizedBox(
                                                height: 28,
                                                child: Chip(
                                                  padding: EdgeInsets.all(0),
                                                  label:Text(
                                                      _medicine.stockQuantity.toString(),
                                                      style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                          0xFF9F2828), height: 1.0))
                                                  ),
                                                  backgroundColor: Color(0xFF9F2828)
                                                      .withOpacity(0.15),
                                                  shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                                                ),
                                              )
                                            ],
                                          )
                                        else
                                          Wrap(
                                            children: [
                                              SizedBox(
                                                height: 32,
                                                child: Chip(
                                                  padding: EdgeInsets.all(0),
                                                  label: Text(
                                                      _medicine.stockQuantity.toString(),
                                                      style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                          0xFF1B8C61), height: 1.0))
                                                  ),
                                                  backgroundColor: Color(0xFF1B8C61)
                                                      .withOpacity(0.15),
                                                  shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                                                ),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                    //SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Start from".tr,
                                          style: Get.textTheme.bodySmall,
                                        ),
                                        Row(
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
                    });
              }),
            ),
          ],
        );
      }
    });
  }
}
