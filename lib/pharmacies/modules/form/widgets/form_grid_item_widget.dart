import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/form_model.dart' as form_model;
import '../../../routes/routes.dart';

class FormGridItemWidget extends StatelessWidget {
  final form_model.Form form;
  final String heroTag;

  FormGridItemWidget({Key? key, required this.form, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
      onTap: () {
        Get.toNamed(Routes.FORM, arguments: form);
      },
      child: Container(
        decoration: Ui.getBoxDecoration(),
        child: Wrap(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [form.color.withOpacity(1), form.color.withOpacity(0.1)],
                    begin: AlignmentDirectional.topStart,
                    //const FractionalOffset(1, 0),
                    end: AlignmentDirectional.bottomEnd,
                    stops: [0.1, 0.9],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: (form.image.url.toLowerCase().endsWith('.svg')
                  ? SvgPicture.network(
                      form.image.url,
                      color: form.color,
                      height: 100,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: form.image.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    form.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
