import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/models/payment_method_model.dart';
import '../../app/models/user_model.dart';
import '../../app/models/wallet_model.dart';
import '../../app/providers/api_provider.dart';
import '../../app/services/settings_service.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/form_model.dart';
import '../models/option_group_model.dart';
import '../models/order_model.dart';
import '../models/order_status_model.dart';
import '../models/medicine_model.dart';
import '../models/pharmacy_model.dart';

class PharmaciesLaravelApiClient with ApiClient {
  PharmaciesLaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl ?? '';
  }

  Future<PharmaciesLaravelApiClient> init() async {
    super.init();
    return this;
  }

  Future<List<Medicine>> getRecommendedMedicines() async {
    if (!Get.find<SettingsService>().isModuleActivated("Pharmacies")) {
      return [];
    }
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      'only': 'id;name;price;discount_price;quantity_unit;has_media;media;stock_quantity',
      'with': 'pharmacy',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getAllMedicinesWithPagination(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> searchMedicines(String? keywords, List<String> categories, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Medicine> getMedicine(String? id) async {
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.taxes;categories;forms',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Medicine.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Pharmacy> getPharmacy(String? pharmacyId) async {
    const _queryParameters = {
      'with': 'pharmacyType;users;addresses',
    };
    Uri _uri = getApiBaseUri("pharmacies/pharmacies/$pharmacyId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Pharmacy.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Pharmacy>> getNearPharmacies(LatLng latLng, LatLng areaLatLng) async {
    var _queryParameters = {
      'only': 'id;name;has_media;media;addresses;available;distance',
      'with': 'addresses',
      'limit': '6',
    };
    _queryParameters['myLat'] = latLng.latitude.toString();
    _queryParameters['myLon'] = latLng.longitude.toString();
    _queryParameters['areaLat'] = areaLatLng.latitude.toString();
    _queryParameters['areaLon'] = areaLatLng.longitude.toString();

    Uri _uri = getApiBaseUri("pharmacies/pharmacies").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Pharmacy>((obj) => Pharmacy.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getPharmacyEmployees(String pharmacyId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token'};
    Uri _uri = getApiBaseUri("pharmacies/pharmacies/$pharmacyId").replace(queryParameters: _queryParameters);
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPharmacyFeaturedMedicines(String? pharmacyId, int page) async {
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'pharmacy_id:$pharmacyId;featured:1',
      'searchFields': 'pharmacy_id:=;featured:=',
      'searchJoin': 'and',
      'limit': '5',
      'offset': ((page - 1) * 5).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPharmacyPopularMedicines(String? pharmacyId, int page) async {
    // TODO popular medicines
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'pharmacy_id:$pharmacyId',
      'searchFields': 'pharmacy_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPharmacyAvailableMedicines(String? pharmacyId, int page) async {
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'pharmacy_id:$pharmacyId',
      'searchFields': 'pharmacy_id:=',
      'available_pharmacy': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPharmacyMostRatedMedicines(String? pharmacyId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'pharmacy_id:$pharmacyId',
      'searchFields': 'pharmacy_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPharmacyMedicines(String? pharmacyId, int page) async {
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'pharmacy_id:$pharmacyId',
      'searchFields': 'pharmacy_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getMedicineOptionGroups(String? medicineId) async {
    var _queryParameters = {
      'with': 'medicineOptions;medicineOptions.media',
      'only': 'id;name;allow_multiple;medicineOptions.id;medicineOptions.name;medicineOptions.description;medicineOptions.price;medicineOptions.medicine_option_group_id;medicineOptions'
          '.medicine_id;medicineOptions.media',
      'search': "medicineOptions.medicine_id:$medicineId",
      'searchFields': 'medicineOptions.medicine_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("pharmacies/medicine_option_groups").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getFeaturedMedicines(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getPopularMedicines(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getMostRatedMedicines(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Medicine>> getAvailableMedicines(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'pharmacy;pharmacy.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'available_pharmacy': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/medicines").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Medicine>((obj) => Medicine.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getSubCategories(String? categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredMedicines',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<Form>> getAllForms() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/forms").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Form>((obj) => Form.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Form>> getFeaturedForms() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredMedicines',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("pharmacies/forms").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Form>((obj) => Form.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<Cart>> getCart() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getCarts() ]");
    }
    var _queryParameters = {
      'with': 'medicine;medicine.pharmacy;medicine.pharmacy.taxes;medicineOptions',
      'api_token': authService.apiToken,
      'search': 'user_id:${authService.user.value.id}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("pharmacies/carts").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Cart>((obj) => Cart.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> addToCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addToCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/carts").replace(queryParameters: _queryParameters);
    var response = await httpClient.postUri(_uri, data: cart.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> updateCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/carts/${cart.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.putUri(_uri, data: cart.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> removeFromCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/carts/${cart.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.deleteUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getCartsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/carts/count").replace(queryParameters: _queryParameters);
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Order>> getOrders(String? statusId, int page) async {
    var _queryParameters = {
      'with': 'orderStatus;payment;payment.paymentStatus', 'api_token': authService.apiToken, // 'search': 'user_id:${authService.user.value.id}',
      'search': 'order_status_id:${statusId}', 'orderBy': 'created_at', 'sortedBy': 'desc', 'limit': '4', 'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("pharmacies/orders").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Order>((obj) => Order.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OrderStatus>> getOrderStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("pharmacies/order_statuses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<OrderStatus>((obj) => OrderStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Order> getOrder(String? orderId) async {
    var _queryParameters = {
      'with': 'orderStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/orders/${orderId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Order.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Order> updateOrder(Order order) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateOrder() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/orders/${order.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.putUri(_uri, data: order.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Order.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Order>> addOrder(List<Order> orders) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addOrder() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/orders").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Order>((obj) => Order.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createPayment(List<Order> orders) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/payments/cash").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media', 'search': 'enabled:1;id:5,6,7,11', // cash, paypal, stripe, wallet
      'searchFields': 'enabled:=;id:in', 'searchJoin': 'and', 'orderBy': 'order', 'sortBy': 'asc', 'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createWalletPayment(List<Order> orders, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("pharmacies/payments/wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Uri getPayPalUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  String getRazorPayUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/razorpay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Uri getStripeUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/stripe/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  String getPayStackUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/paystack/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/paymongo/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/flutterwave/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("pharmacies/payments/stripe-fpx/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }
}
