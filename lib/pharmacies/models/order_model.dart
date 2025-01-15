import '../../app/models/address_model.dart';
import '../../app/models/parents/model.dart';
import '../../app/models/payment_model.dart';
import '../../app/models/tax_model.dart';
import '../../app/models/user_model.dart';
import 'option_model.dart';
import 'order_status_model.dart';
import 'medicine_model.dart';
import 'pharmacy_model.dart';

class Order extends Model {
  String? _note;

  bool? _cancel;

  int? _quantity;

  OrderStatus? _status;

  User? _user;

  Medicine? _medicine;

  Pharmacy? _store;

  List<Option>? _options;

  List<Tax>? _taxes;

  Address? _address;

  DateTime? _orderAt;

  Payment? _payment;

  Order(
      {String? id,
      String? note,
      bool? cancel,
      int? quantity,
      OrderStatus? status,
      User? user,
      Medicine? medicine,
      Pharmacy? pharmacy,
      List<Option>? options,
      List<Tax>? taxes,
      Address? address,
      DateTime? orderAt,
      Payment? payment}) {
    this.id = id;
    this._note = note;
    this._cancel = cancel;
    this._quantity = quantity;
    this._status = status;
    this._user = user;
    this._medicine = medicine;
    this._store = pharmacy;
    this._options = options;
    this._taxes = taxes;
    this._address = address;
    this._orderAt = orderAt;
    this._payment = payment;
  }

  Order.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _note = stringFromJson(json, 'note');
    _cancel = boolFromJson(json, 'cancel');
    _quantity = intFromJson(json, 'quantity');
    _status = objectFromJson(json, 'order_status', (v) => OrderStatus.fromJson(v));
    _user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    _medicine = objectFromJson(json, 'medicine', (v) => Medicine.fromJson(v));
    _store = objectFromJson(json, 'pharmacy', (v) => Pharmacy.fromJson(v));
    _address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    _payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    _options = listFromJson(json, 'medicine_options', (v) => Option.fromJson(v));
    _taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    _orderAt = dateFromJson(json, 'order_at', defaultValue: null);
  }

  Address get address => _address ?? Address();

  set address(Address? value) {
    _address = value;
  }

  bool get cancel => _cancel ?? false;

  set cancel(bool? value) {
    _cancel = value;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      note.hashCode ^
      cancel.hashCode ^
      quantity.hashCode ^
      status.hashCode ^
      user.hashCode ^
      medicine.hashCode ^
      pharmacy.hashCode ^
      options.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      orderAt.hashCode ^
      payment.hashCode;

  String get note => _note ?? '';

  set note(String? value) {
    _note = value;
  }

  List<Option> get options => _options ?? [];

  set options(List<Option>? value) {
    _options = value;
  }

  DateTime? get orderAt => _orderAt;

  set orderAt(DateTime? value) {
    _orderAt = value;
  }

  Payment? get payment => _payment;

  set payment(Payment? value) {
    _payment = value;
  }

  Medicine get medicine => _medicine ?? Medicine();

  set medicine(Medicine? value) {
    _medicine = value;
  }

  int get quantity => _quantity ?? 1;

  set quantity(int? value) {
    _quantity = value;
  }

  OrderStatus get status => _status ?? OrderStatus();

  set status(OrderStatus? value) {
    _status = value;
  }

  Pharmacy get pharmacy => _store ?? Pharmacy();

  set pharmacy(Pharmacy? value) {
    _store = value;
  }

  List<Tax> get taxes => _taxes ?? [];

  set taxes(List<Tax>? value) {
    _taxes = value;
  }

  User get user => _user ?? User();

  set user(User? value) {
    _user = value;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          note == other.note &&
          cancel == other.cancel &&
          quantity == other.quantity &&
          status == other.status &&
          user == other.user &&
          medicine == other.medicine &&
          pharmacy == other.pharmacy &&
          options == other.options &&
          taxes == other.taxes &&
          address == other.address &&
          orderAt == other.orderAt &&
          payment == other.payment;

  double getSubtotal() {
    double total = 0.0;
    total = medicine.getPrice * (quantity >= 1 ? quantity : 1);
    options.forEach((element) {
      total += element.price * (quantity >= 1 ? quantity : 1);
    });
    return total;
  }

  double getTaxesValue() {
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    return total;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) {
      data['id'] = this.id;
    }
    if (this._note != null) {
      data['note'] = this.note;
    }
    if (this._quantity != null) {
      data['quantity'] = this.quantity;
    }
    if (this._cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this._status != null) {
      data['order_status_id'] = this.status.id;
    }
    if (this._taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this._options != null && this.options.isNotEmpty) {
      data['medicine_options'] = this.options.map((e) => e.id).toList();
    }
    if (this._user != null) {
      data['user_id'] = this.user.id;
    }
    if (this._address != null) {
      data['address'] = this.address.toJson();
    }
    if (this._medicine != null) {
      data['medicine'] = this.medicine.id;
    }
    if (this._store != null) {
      data['pharmacy'] = this.pharmacy.toJson();
    }
    if (this._payment != null) {
      data['payment'] = this._payment!.toJson();
    }
    if (this._orderAt != null) {
      data['order_at'] = _orderAt!.toUtc().toString();
    }
    return data;
  }
}
