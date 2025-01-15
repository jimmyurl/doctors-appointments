/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../routes/routes.dart';
import 'order_options_popup_menu_widget.dart';

class OrdersListItemWidget extends StatelessWidget {
  const OrdersListItemWidget({
    Key? key,
    required Order order,
  })  : _order = order,
        super(key: key);

  final Order _order;

  @override
  Widget build(BuildContext context) {
    Color _color = _order.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ORDER, arguments: _order);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: _order.medicine.firstImageThumb,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 80,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  ),
                ),
                if (_order.payment != null)
                  Container(
                    width: 80,
                    child: Text(_order.payment?.paymentStatus.status ?? '',
                        style: Get.textTheme.bodySmall!.merge(
                          TextStyle(fontSize: 10),
                        ),
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Text(DateFormat('HH:mm', Get.locale.toString()).format(_order.orderAt!),
                          maxLines: 1,
                          style: Get.textTheme.bodyMedium!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1.4),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('dd', Get.locale.toString()).format(_order.orderAt!),
                          maxLines: 1,
                          style: Get.textTheme.displaySmall!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('MMM', Get.locale.toString()).format(_order.orderAt!),
                          maxLines: 1,
                          style: Get.textTheme.bodyMedium!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Opacity(
                opacity: _order.cancel ? 0.3 : 1,
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _order.medicine.name,
                            style: Get.textTheme.bodyMedium,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                        ),
                        OrderOptionsPopupMenuWidget(order: _order),
                      ],
                    ),
                    Divider(height: 8, thickness: 1, color: Get.theme.dividerColor,),
                    Row(
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _order.pharmacy.name,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _order.address.address,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 8, thickness: 1, color: Get.theme.dividerColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Total".tr,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Ui.getPrice(
                              _order.getTotal(),
                              style: Get.textTheme.titleLarge?.merge(TextStyle(color: _color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
