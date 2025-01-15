import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../controllers/order_controller.dart';
import '../controllers/orders_controller.dart';
import '../widgets/order_actions_widget.dart';
import '../widgets/order_row_widget.dart';
import '../widgets/order_til_widget.dart';
import '../widgets/order_title_bar_widget.dart';

class OrderView extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OrderActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<PharmaciesLaravelApiClient>().forceRefresh();
            controller.refreshOrder(showMessage: true);
            Get.find<PharmaciesLaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 370,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () async {
                    Get.find<OrdersController>().refreshOrders();
                    Get.back();
                  },
                ),
                bottom: buildOrderTitleBarWidget(controller.order),
                flexibleSpace: Obx(() {
                  if (!controller.order.value.address.hasData)
                    return SizedBox();
                  else
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: MapsUtil.getStaticMaps(controller.order.value.address.getLatLng(), height: 600, size: '700x600', zoom: 14),
                    );
                }).marginOnly(bottom: 68),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildContactProvider(controller.order.value),
                    Obx(() {
                      if (!controller.order.value.status.hasData)
                        return SizedBox();
                      else
                        return OrderTilWidget(
                          title: Text("Order Details".tr, style: Get.textTheme.titleSmall),
                          actions: [Text("#" + controller.order.value.id, style: Get.textTheme.titleSmall)],
                          content: Column(
                            children: [
                              OrderRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.order.value.status.status,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              OrderRowWidget(
                                  description: "Payment Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.order.value.payment?.paymentStatus.status ?? "Not Paid".tr,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              if (controller.order.value.payment?.paymentMethod != null)
                                OrderRowWidget(
                                    description: "Payment Method".tr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Get.theme.focusColor.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            controller.order.value.payment?.paymentMethod.name ?? "Not Paid".tr,
                                            style: TextStyle(color: Get.theme.hintColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    hasDivider: true),
                              OrderRowWidget(
                                description: "Note".tr,
                                child: Ui.removeHtml(controller.order.value.note, alignment: Alignment.centerRight, textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (!controller.order.value.medicine.hasData)
                        return SizedBox();
                      else
                        return OrderTilWidget(
                          title: Text("Pricing".tr, style: Get.textTheme.titleSmall),
                          content: Column(
                            children: [
                              OrderRowWidget(
                                  descriptionFlex: 2,
                                  valueFlex: 1,
                                  description: controller.order.value.medicine.name,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.order.value.medicine.getPrice, style: Get.textTheme.titleSmall),
                                  ),
                                  hasDivider: true),
                              Column(
                                children: List.generate(controller.order.value.options.length, (index) {
                                  var _option = controller.order.value.options.elementAt(index);
                                  return OrderRowWidget(
                                      descriptionFlex: 2,
                                      valueFlex: 1,
                                      description: _option.name,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Ui.getPrice(_option.price, style: Get.textTheme.bodyLarge),
                                      ),
                                      hasDivider: (controller.order.value.options.length - 1) == index);
                                }),
                              ),
                              OrderRowWidget(
                                  description: "Quantity".tr,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "x" + controller.order.value.quantity.toString() + " " + controller.order.value.medicine.quantityUnit.tr,
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ),
                                  hasDivider: true),
                              Column(
                                children: List.generate(controller.order.value.taxes.length, (index) {
                                  var _tax = controller.order.value.taxes.elementAt(index);
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
                                      hasDivider: (controller.order.value.taxes.length - 1) == index);
                                }),
                              ),
                              Obx(() {
                                return OrderRowWidget(
                                  description: "Tax Amount".tr,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.order.value.getTaxesValue(), style: Get.textTheme.titleSmall),
                                  ),
                                  hasDivider: false,
                                );
                              }),
                              Obx(() {
                                return OrderRowWidget(
                                    description: "Subtotal".tr,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Ui.getPrice(controller.order.value.getSubtotal(), style: Get.textTheme.titleSmall),
                                    ),
                                    hasDivider: true);
                              }),
                              Obx(() {
                                return OrderRowWidget(
                                  description: "Total Amount".tr,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.order.value.getTotal(), style: Get.textTheme.titleLarge),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                    })
                  ],
                ),
              ),
            ],
          )),
    );
  }

  OrderTitleBarWidget buildOrderTitleBarWidget(Rx<Order> _order) {
    return OrderTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _order.value.medicine.name,
                    style: Get.textTheme.headlineSmall!.merge(TextStyle(height: 1.1)),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Get.theme.focusColor),
                      SizedBox(width: 3),
                      Text(
                        _order.value.user.name,
                        style: Get.textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(_order.value.address.address, maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyLarge),
                      ),
                    ],
                    // spacing: 8,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm', Get.locale.toString()).format(_order.value.orderAt!),
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('dd', Get.locale.toString()).format(_order.value.orderAt!),
                      maxLines: 1,
                      style: Get.textTheme.displaySmall!.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('MMM', Get.locale.toString()).format(_order.value.orderAt!),
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                ],
              ),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            ),
          ],
        );
      }),
    );
  }

  Container buildContactProvider(Order _order) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Pharmacy".tr, style: Get.textTheme.titleSmall),
                Text(_order.pharmacy.phoneNumber, style: Get.textTheme.bodySmall),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${_order.pharmacy.phoneNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
