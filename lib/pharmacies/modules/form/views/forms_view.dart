import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/circular_loading_widget.dart';
import '../../../../app/modules/global_widgets/home_search_bar_widget.dart';
import '../../../../app/modules/global_widgets/notifications_button_widget.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../global_widgets/cart_button_widget.dart';
import '../controllers/forms_controller.dart';
import '../widgets/form_grid_item_widget.dart';
import '../widgets/form_list_item_widget.dart';

class FormsView extends GetView<FormsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Medicine Forms".tr,
            style: Get.textTheme.titleLarge,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
          actions: [CartButtonWidget(), NotificationsButtonWidget()],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<PharmaciesLaravelApiClient>().forceRefresh();
            controller.refreshForms(showMessage: true);
            Get.find<PharmaciesLaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            children: [
              HomeSearchBarWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "Forms of Medicines".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headlineSmall,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          controller.layout.value = FormsLayout.LIST;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.format_list_bulleted,
                            color: controller.layout.value == FormsLayout.LIST ? Get.theme.colorScheme.secondary : Get.theme.focusColor,
                          );
                        }),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.layout.value = FormsLayout.GRID;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.apps,
                            color: controller.layout.value == FormsLayout.GRID ? Get.theme.colorScheme.secondary : Get.theme.focusColor,
                          );
                        }),
                      )
                    ],
                  ),
                ]),
              ),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != FormsLayout.GRID,
                  child: controller.forms.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : MasonryGridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: controller.forms.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FormGridItemWidget(form: controller.forms.elementAt(index), heroTag: "heroTag");
                          },
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                );
              }),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != FormsLayout.LIST,
                  child: controller.forms.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.forms.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return FormListItemWidget(
                              heroTag: 'form_list',
                              expanded: index == 0,
                              form: controller.forms.elementAt(index),
                            );
                          },
                        ),
                );
              }),
            ],
          ),
        ));
  }
}
