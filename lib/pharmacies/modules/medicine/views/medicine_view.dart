import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/pharmacies/modules/medicine/widgets/add_to_cart_widget.dart';
import '../../../../app/models/media_model.dart';
import '../../../../app/modules/global_widgets/circular_loading_widget.dart';
import '../../../../app/modules/global_widgets/notifications_button_widget.dart';
import '../../../../common/ui.dart';
import '../../../models/medicine_model.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../../routes/routes.dart';
import '../../global_widgets/cart_button_widget.dart';
import '../controllers/medicine_controller.dart';
import '../widgets/option_group_item_widget.dart';
import '../widgets/medicine_til_widget.dart';
import '../widgets/medicine_title_bar_widget.dart';
import '../widgets/pharmacy_item_widget.dart';

class MedicineView extends GetView<MedicineController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _medicine = controller.medicine.value;
      if (!_medicine.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: AddToCartWidget(),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<PharmaciesLaravelApiClient>().forceRefresh();
                controller.refreshMedicine(showMessage: true);
                Get.find<PharmaciesLaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [CartButtonWidget(), NotificationsButtonWidget()],
                    bottom: buildMedicineTitleBarWidget(_medicine),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_medicine),
                            buildCarouselBullets(_medicine),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildCategories(_medicine),
                        buildForms(_medicine),
                        MedicineTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.medicine.value.description == '') {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_medicine.description, style: Get.textTheme.bodyLarge);
                          }),
                        ),
                        MedicineTilWidget(
                          title: Text("Storage Conditions".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.medicine.value.storageConditions == '') {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_medicine.storageConditions, style: Get.textTheme.bodyLarge);
                          }),
                        ),
                        buildOptions(_medicine),
                        buildPharmacy(_medicine),
                        MedicineTilWidget(
                          title: Text("Medicine Details".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.medicine.value.manufacturer == '' || controller.medicine.value.genericName == '') {
                              return SizedBox();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Generic name: '+_medicine.genericName,
                                    style: Get.textTheme.titleSmall?.merge(TextStyle(fontSize: 12)),
                                    textAlign: TextAlign.left,

                                ),
                                SizedBox(height: 10),
                                Text(
                                    'Manufacturer: '+_medicine.manufacturer,
                                    style: Get.textTheme.titleSmall?.merge(TextStyle(fontSize: 12)),
                                    textAlign: TextAlign.left,
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildOptions(Medicine _medicine) {
    return Obx(() {
      if (controller.optionGroups.isEmpty) {
        return SizedBox();
      }
      return MedicineTilWidget(
        horizontalPadding: 0,
        title: Text("Options".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemCount: controller.optionGroups.length,
          primary: false,
          shrinkWrap: true,
        ),
      );
    });
  }

  CarouselSlider buildCarouselSlider(Medicine _medicine) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _medicine.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _medicine.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Medicine _medicine) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _medicine.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _medicine.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  MedicineTitleBarWidget buildMedicineTitleBarWidget(Medicine _medicine) {
    return MedicineTitleBarWidget(
      title: Column(
        children: [
          Expanded(
            child:
            Row(
              children: [
                Text(
                  _medicine.name,
                  style: Get.textTheme.headlineSmall!.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(width: 5),
                Text(
                  _medicine.strength,
                  style: Get.textTheme.bodyLarge?.merge(TextStyle(color: Get.theme.focusColor)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_medicine.stockQuantity < 10)
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
                                    0xFF9F2828), height: 1.4))
                            ),
                            Text(
                                ' Items',
                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                    0xFF9F2828), height: 1.4))
                            ),
                          ],
                        ),
                        backgroundColor: Color(0xFF9F2828).withOpacity(0.15),
                        shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                      ),
                    )
                  ],
                ).marginOnly(bottom: 10)
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
                                    0xFF1B8C61), height: 1.4))
                            ),
                            Text(
                                ' Items',
                                style: Get.textTheme.bodySmall?.merge(TextStyle(color: Color(
                                    0xFF1B8C61), height: 1.4))
                            ),
                          ],
                        ),
                        backgroundColor: Color(0xFF1B8C61)
                            .withOpacity(0.15),
                        shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                      ),
                    )
                  ],
                ).marginOnly(bottom: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_medicine.getOldPrice > 0)
                    Ui.getPrice(
                      _medicine.getOldPrice,
                      style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                      unit: _medicine.quantityUnit,
                    ),
                  Ui.getPrice(
                    _medicine.getPrice,
                    style: Get.textTheme.displaySmall!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                    unit: _medicine.quantityUnit,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(Medicine _medicine) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_medicine.categories.length, (index) {
              var _category = _medicine.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name, style: Get.textTheme.bodyLarge!.merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_medicine.subCategories.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_medicine.subCategories.elementAt(index).name, style: Get.textTheme.bodySmall),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildForms(Medicine _medicine) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_medicine.forms.length, (index) {
          var _form = _medicine.forms.elementAt(index);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(_form.name, style: Get.textTheme.bodyLarge!.merge(TextStyle(color: _form.color))),
            decoration: BoxDecoration(
                color: _form.color.withOpacity(0.2),
                border: Border.all(
                  color: _form.color.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          );
        })+List.generate(_medicine.subCategories.length, (index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(_medicine.subCategories.elementAt(index).name, style: Get.textTheme.bodySmall),
          decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              border: Border.all(
                color: Get.theme.focusColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        );
      }),
      ),
    );
  }

  Widget buildPharmacy(Medicine _medicine) {
    if (_medicine.pharmacy.hasData) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.PHARMACY, arguments: {'pharmacy': _medicine.pharmacy, 'heroTag': 'medicine_details'});
        },
        child: MedicineTilWidget(
          title: Text("Pharmacy".tr, style: Get.textTheme.titleSmall),
          content: PharmacyItemWidget(pharmacy: _medicine.pharmacy),
          actions: [
            Text("View More".tr, style: Get.textTheme.titleMedium),
          ],
        ),
      );
    } else {
      return MedicineTilWidget(
        title: Text("Pharmacy".tr, style: Get.textTheme.titleSmall),
        content: SizedBox(
          height: 60,
        ),
        actions: [],
      );
    }
  }
}
