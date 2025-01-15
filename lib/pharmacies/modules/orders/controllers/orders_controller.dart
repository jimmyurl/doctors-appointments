import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/services/global_service.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../models/order_status_model.dart';
import '../../../repositories/order_repository.dart';

class OrdersController extends GetxController {
  late OrderRepository _ordersRepository;
  final orders = <Order>[].obs;
  final orderStatuses = <OrderStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  late ScrollController scrollOrdersController;

  OrdersController() {
    _ordersRepository = new OrderRepository();
    scrollOrdersController = new ScrollController();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getOrderStatuses();
    currentStatus.value = getStatusByOrder(1).id;
  }

  void loadMoreBookingsOnScroll() {
    scrollOrdersController = new ScrollController();
    scrollOrdersController.addListener(() {
      if (scrollOrdersController.position.pixels == scrollOrdersController.position.maxScrollExtent && !isDone.value) {
        loadOrdersOfStatus(statusId: currentStatus.value);
      }
    });
  }

  @override
  void dispose() {
    scrollOrdersController.dispose();
    super.dispose();
  }

  Future refreshOrders({bool showMessage = false, String? statusId}) async {
    changeTab(statusId);
    if (showMessage) {
      await getOrderStatuses();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Orders page refreshed successfully".tr));
    }
  }

  void changeTab(String? statusId) async {
    this.orders.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadOrdersOfStatus(statusId: currentStatus.value);
  }

  Future getOrderStatuses() async {
    try {
      orderStatuses.assignAll(await _ordersRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  OrderStatus getStatusByOrder(int? order) => orderStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Order status not found".tr));
        return OrderStatus();
      });

  Future loadOrdersOfStatus({String? statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Order> _orders = [];
      if (orderStatuses.isNotEmpty) {
        _orders = await _ordersRepository.all(statusId, page: page.value);
      }
      if (_orders.isNotEmpty) {
        orders.addAll(_orders);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(Order order) async {
    try {
      if (order.status.order < (Get.find<GlobalService>().global.value.onTheWay ?? 0)) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _order = new Order(id: order.id, cancel: true, status: _status);
        await _ordersRepository.update(_order);
        orders.removeWhere((element) => element.id == order.id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
