import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/pharmacy_model.dart';

class PharmacyItemWidget extends StatelessWidget {
  final Pharmacy pharmacy;

  PharmacyItemWidget({Key? key, required this.pharmacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                imageUrl: pharmacy.firstImageThumb,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  height: 65,
                  width: 65,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    pharmacy.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium!.merge(TextStyle(color: Theme.of(context).hintColor)),
                  ),
                  SizedBox(height: 5),
                  Ui.removeHtml(
                    pharmacy.description.substring(0, min(pharmacy.description.length, 50)),
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        // Text(
        //   review.review,
        //   style: Theme.of(context).textTheme.bodySmall,
        //   overflow: TextOverflow.ellipsis,
        //   softWrap: false,
        //   maxLines: 3,
        // )
      ],
    );
  }
}
