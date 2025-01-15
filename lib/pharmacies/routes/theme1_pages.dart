import 'package:get/get.dart' show GetPage;

import '../../app/middlewares/auth_middleware.dart';
import '../models/pharmacy_model.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/cash_view.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/confirmation_view.dart';
import '../modules/checkout/views/paypal_view.dart';
import '../modules/checkout/views/stripe_view.dart';
import '../modules/checkout/views/wallet_view.dart';
import '../modules/form/bindings/form_binding.dart';
import '../modules/form/views/form_view.dart';
import '../modules/form/views/forms_view.dart';
import '../modules/order_confirmation/bindings/order_confirmation_binding.dart';
import '../modules/order_confirmation/views/order_confirmation_view.dart';
import '../modules/orders/bindings/order_binding.dart';
import '../modules/orders/views/order_view.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/medicine/bindings/medicine_binding.dart';
import '../modules/medicine/views/medicine_view.dart';
import '../modules/pharmacies_maps/bindings/pharmacies_maps_binding.dart';
import '../modules/pharmacies_maps/views/pharmacies_maps_view.dart';
import '../modules/pharmacy/bindings/pharmacy_binding.dart';
import '../modules/pharmacy/views/pharmacy_medicines_view.dart';
import '../modules/pharmacy/views/pharmacy_view.dart';
import 'routes.dart';

class Theme1PharmaciesPages {
  static final routes = [
    GetPage(name: Routes.CATEGORIES, page: () => CategoriesView(), bindings: [CategoryBinding(), CartBinding()]),
    GetPage(name: Routes.CATEGORY, page: () => CategoryView(), bindings: [CategoryBinding(), CartBinding()]),
    GetPage(name: Routes.FORMS, page: () => FormsView(), bindings: [FormBinding(), CartBinding()]),
    GetPage(name: Routes.FORM, page: () => FormView(), bindings: [FormBinding(), CartBinding()]),
    GetPage(name: Routes.MEDICINE, page: () => MedicineView(), bindings: [MedicineBinding(), CartBinding()]),
    GetPage(name: Routes.PHARMACY, page: () => PharmacyView(), binding: PharmacyBinding()),
    GetPage(name: Routes.PHARMACY_MEDICINES, page: () => PharmacyMedicinesView(), binding: PharmacyBinding()),
    GetPage(name: Routes.PHARMACIES_MAPS, page: () => PharmaciesMapsView(), binding: PharmaciesMapsBinding()),
    GetPage(name: Routes.ORDERS, page: () => OrdersView(), bindings: [OrderBinding(), CartBinding()], middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.ORDER, page: () => OrderView(), binding: OrderBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CART, page: () => CartView(), binding: CartBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.ORDER_CONFIRMATION, page: () => OrderConfirmationView(), binding: OrderConfirmationBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYMENT_CONFIRMATION, page: () => ConfirmationView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHECKOUT, page: () => CheckoutView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CASH, page: () => CashViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.WALLET, page: () => WalletViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYPAL, page: () => PayPalViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE, page: () => StripeViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    /*GetPage(name: Routes.E_SERVICE, page: () => MedicineView(), binding: MedicineBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.BOOK_E_SERVICE, page: () => BookMedicineView(), binding: BookMedicineBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.BOOKING_SUMMARY, page: () => OrderSummaryView(), binding: BookMedicineBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.RAZORPAY, page: () => RazorPayViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE_FPX, page: () => StripeFPXViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYSTACK, page: () => PayStackViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYMONGO, page: () => PayMongoViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FLUTTERWAVE, page: () => FlutterWaveViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    */
  ];
}
