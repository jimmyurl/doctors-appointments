import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/cart_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/medicine_model.dart';
import '../../../repositories/cart_repository.dart';

class CartController extends GetxController {
  final carts = <Cart>[].obs;
  late CartRepository _cartRepository;

  CartController() {
    _cartRepository = new CartRepository();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshCart();
    super.onReady();
  }

  Future refreshCart({bool showMessage = false}) async {
    await getCart();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "cart page refreshed successfully".tr));
    }
  }

  Future getCart() async {
    try {
      carts.value = await _cartRepository.getCart();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectOption(OptionGroup optionGroup, Option option) {
    optionGroup.options.forEach((e) {
      if (!optionGroup.allowMultiple && option != e) {
        e.checked.value = false;
      }
    });
    option.checked.value = !option.checked.value;
  }

  void incrementQuantity(Cart cart) {
    if (cart.quantity < 1000) {
      cart.quantity.value++;
      _cartRepository.updateCart(cart);
      carts.refresh();
    }
  }

  void decrementQuantity(Cart cart) async {
    if (cart.quantity > 1) {
      cart.quantity.value--;
      await _cartRepository.updateCart(cart);
      carts.refresh();
    }
  }

  double getTaxesValue() {
    double taxes = 0;
    carts.forEach((cart) {
      taxes += cart.getTaxesValue();
    });
    return taxes;
  }

  double getSubtotal() {
    double subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.getSubtotal();
    });
    return subTotal;
  }

  double getTotal() {
    double total = 0;
    carts.forEach((cart) {
      total += cart.getTotal();
    });
    return total;
  }

  Future addToCart(Medicine medicine, Rx<int> quantity, List<Option> options) async {
    try {
      Cart _cartObject = Cart(pharmacy: medicine.pharmacy, taxes: medicine.pharmacy.taxes, medicine: medicine, quantity: quantity, options: options);
      if (carts.contains(_cartObject)) {
        var _cart = carts.firstWhere((element) => element == _cartObject);
        _cart.quantity.value += quantity.value;
        await _cartRepository.updateCart(_cart);
      } else {
        carts.insert(0, await _cartRepository.addToCart(_cartObject));
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: medicine.name + " " + "added to cart successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void removeFromCart(Cart cart) async {
    carts.removeWhere((element) => element.id == cart.id);
    await _cartRepository.removeFromCart(cart);
  }

  void createOrder() {}
}
