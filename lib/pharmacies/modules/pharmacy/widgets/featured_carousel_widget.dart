import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/circular_loading_widget.dart';
import '../../../../common/ui.dart';
import '../../../routes/routes.dart';
import '../controllers/store_controller.dart';

class FeaturedCarouselWidget extends GetWidget<PharmacyController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: Get.theme.primaryColor,
      child: Obx(() {
        if (controller.featuredMedicines.isEmpty) {
          return CircularLoadingWidget(height: 250);
        }
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.featuredMedicines.length,
            itemBuilder: (_, index) {
              var _medicine = controller.featuredMedicines.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MEDICINE, arguments: {'medicine': _medicine, 'heroTag': 'featured_carousel'});
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'featured_carousel' + _medicine.id,
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
                              height: 140,
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
                                        label: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                _medicine.stockQuantity.toString(),
                                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                    0xFF9F2828), height: 1.0))
                                            ),
                                            Text(
                                                ' Items',
                                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                    0xFF9F2828), height: 1.0))
                                            ),
                                          ],
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
                                        label: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[

                                            Text(
                                                _medicine.stockQuantity.toString(),
                                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                    0xFF1B8C61), height: 1.0))
                                            ),
                                            Text(
                                                ' Items',
                                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                                    0xFF1B8C61), height: 1.0))
                                            ),
                                          ],
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
    );
  }
}
