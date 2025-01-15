import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/faq_model.dart';

class FaqItemWidget extends StatelessWidget {
  final Faq faq;

  FaqItemWidget({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Ui.removeHtml(this.faq.question, style: Get.textTheme.bodyMedium),
          Divider(
            height: 30,
            thickness: 1,
            color: Get.theme.dividerColor,
          ),
          Ui.applyHtml(this.faq.answer, style: Get.textTheme.bodySmall)
        ],
      ),
    );
  }
}
