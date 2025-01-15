import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/modules/global_widgets/main_drawer_widget.dart';
import '../../../../app/modules/global_widgets/notifications_button_widget.dart';
import '../../../../app/modules/global_widgets/tab_bar_widget.dart';
import '../../../providers/pharmacies_laravel_provider.dart';
import '../../global_widgets/cart_button_widget.dart';
import '../controllers/orders_controller.dart';
import '../widgets/orders_list_widget.dart';

class OrdersView extends GetView<OrdersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawerWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            if (!Get.find<PharmaciesLaravelApiClient>().isLoading(task: 'getOrders')) {
              Get.find<PharmaciesLaravelApiClient>().forceRefresh();
              controller.refreshOrders(showMessage: true, statusId: controller.currentStatus.value);
              Get.find<PharmaciesLaravelApiClient>().unForceRefresh();
            }
          },
          child: CustomScrollView(
            controller: controller.scrollOrdersController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              Obx(() {
                return SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 120,
                  elevation: 0.5,
                  floating: false,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    "Orders".tr,
                    style: Get.textTheme.titleLarge,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: Builder(builder: (context) {
                    return new IconButton(
                      icon: new Icon(Icons.sort, color: Colors.black87),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    );
                  }),
                  actions: [CartButtonWidget(), NotificationsButtonWidget()],
                  bottom: controller.orderStatuses.isEmpty
                      ? TabBarLoadingWidget()
                      : TabBarWidget(
                          tag: 'orders',
                          initialSelectedId: controller.orderStatuses.elementAt(0).id,
                          tabs: List.generate(controller.orderStatuses.length, (index) {
                            var _status = controller.orderStatuses.elementAt(index);
                            return ChipWidget(
                              tag: 'orders',
                              text: _status.status,
                              id: _status.id,
                              onSelected: (id) {
                                controller.changeTab(id);
                              },
                            );
                          }),
                        ),
                );
              }),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    OrdersListWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
