import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/form_model.dart' as form_model;
import '../../../routes/routes.dart';

class FormListItemWidget extends StatelessWidget {
  final form_model.Form form;
  final String heroTag;
  final bool expanded;

  FormListItemWidget(
      {Key? key,
      required this.form,
      required this.heroTag,
      this.expanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: Ui.getBoxDecoration(
          border: Border.fromBorderSide(BorderSide.none),
          gradient: new LinearGradient(
              colors: [
                form.color.withOpacity(0.6),
                form.color.withOpacity(0.1)
              ],
              begin: AlignmentDirectional.topStart,
              //const FractionalOffset(1, 0),
              end: AlignmentDirectional.topEnd,
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp)),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: this.expanded,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
              onTap: () {
                Get.toNamed(Routes.FORM, arguments: form);
                //Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: market.id, heroTag: heroTag));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      form.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                  // TODO get medicine for each form
                  // Text(
                  //   "(" + form.medicines.length.toString() + ")",
                  //   overflow: TextOverflow.fade,
                  //   softWrap: false,
                  //   style: Get.textTheme.bodySmall,
                  // ),
                ],
              )),
          // children: List.generate(form.forms.length, (index) {
          //   var _form = form.subForms.elementAt(index);
          //   return GestureDetector(
          //     onTap: () {
          //       Get.toNamed(Routes.FORM, arguments: _form);
          //     },
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          //       child: Text(_form.name, style: Get.textTheme.bodyLarge),
          //       decoration: BoxDecoration(
          //         color: Get.theme.scaffoldBackgroundColor.withOpacity(0.2),
          //         border: Border(top: BorderSide(color: Get.theme.scaffoldBackgroundColor.withOpacity(0.3))),
          //       ),
          //     ),
          //   );
          // }),
        ),
      ),
    );
  }
}
