import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/models/message_model.dart';
import '../../../../app/models/user_model.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/global_service.dart';
import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/order_model.dart';
import '../../../models/order_status_model.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/pharmacy_repository.dart';
import 'orders_controller.dart';

class OrderController extends GetxController {
  late PharmacyRepository _storeRepository;
  late OrderRepository _orderRepository;
  final allMarkers = <Marker>[].obs;
  final orderStatuses = <OrderStatus>[].obs;
  Timer? timer;
  late GoogleMapController mapController;
  final order = Order().obs;

  OrderController() {
    _orderRepository = OrderRepository();
    _storeRepository = PharmacyRepository();
  }

  @override
  void onInit() async {
    order.value = Get.arguments as Order;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshOrder();
    super.onReady();
  }

  Future refreshOrder({bool showMessage = false}) async {
    await getOrder();
    initOrderAddress();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Order page refreshed successfully".tr));
    }
  }

  Future<void> getOrder() async {
    try {
      order.value = await _orderRepository.get(order.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> cancelOrder() async {
    try {
      if (order.value.status.order < (Get.find<GlobalService>().global.value.onTheWay ?? 0) && order.value.payment == null) {
        final _status = Get.find<OrdersController>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _order = new Order(id: order.value.id, cancel: true, status: _status);
        await _orderRepository.update(_order);
        order.update((val) {
          val?.cancel = true;
          val?.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initOrderAddress() {
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: order.value.address.getLatLng(), zoom: 12.4746),
      ),
    );
    MapsUtil.getMarker(address: order.value.address, id: order.value.id, description: order.value.user.name).then((marker) {
      allMarkers.add(marker);
    });
  }

  Future<void> startChat() async {
    List<User> _employees = await _storeRepository.getEmployees(order.value.pharmacy.id);
    _employees = _employees
        .map((e) {
          e.avatar = order.value.pharmacy.images[0];
          return e;
        })
        .toSet()
        .toList();
    Message _message = new Message(_employees, name: order.value.pharmacy.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
