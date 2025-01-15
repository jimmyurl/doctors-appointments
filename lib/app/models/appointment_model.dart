import 'patient_model.dart';

import 'address_model.dart';
import 'appointment_status_model.dart';
import 'coupon_model.dart';
import 'clinic_model.dart';
import 'doctor_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Appointment extends Model {

  String? _hint;
  bool? _cancel;
  bool? _online;
  double? _duration;
  AppointmentStatus? _status;
  User? _user ;
  Doctor? _doctor ;
  Clinic? _clinic ;
  Patient? _patient ;
  List<Tax>? _taxes;
  Address? _address ;
  Coupon? _coupon;
  DateTime? _appointmentAt;
  DateTime? _startAt;
  DateTime? _endsAt;
  Payment? _payment ;

  Appointment(
      {String? id,
      String? hint,
      bool? cancel,
      bool? online,
      double? duration = 0,
      AppointmentStatus? status,
      User? user,
      Doctor? doctor,
      Clinic? clinic,
      Patient? patient,
      List<Tax>? taxes,
      Address? address,
      Coupon? coupon,
      DateTime? appointmentAt,
      DateTime? startAt,
      DateTime? endsAt,
      Payment? payment}) {
    this.id = id;
    _payment = payment;
    _endsAt = endsAt;
    _startAt = startAt;
    _appointmentAt = appointmentAt;
    _coupon = coupon;
    _address = address;
    _taxes = taxes;
    _patient = patient;
    _clinic = clinic;
    _doctor = doctor;
    _user = user;
    _status = status;
    _duration = duration;
    _online = online;
    _cancel = cancel;
    _hint = hint;
  }




  Appointment.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _hint = stringFromJson(json, 'hint');
    _cancel = boolFromJson(json, 'cancel');
    _online = boolFromJson(json, 'online');
    _duration = doubleFromJson(json, 'duration');
    _status = objectFromJson(json, 'appointment_status', (v) => AppointmentStatus.fromJson(v));
    _user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    _doctor = objectFromJson(json, 'doctor', (v) => Doctor.fromJson(v));
    _clinic = objectFromJson(json, 'clinic', (v) => Clinic.fromJson(v));
    _patient = objectFromJson(json, 'patient', (v) => Patient.fromJson(v));
    _address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    _coupon = objectFromJson(json, 'coupon', (v) => Coupon.fromJson(v));
    _payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    _taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    _appointmentAt = dateFromJson(json, 'appointment_at', defaultValue: null);
    _startAt = dateFromJson(json, 'start_at', defaultValue: null);
    _endsAt = dateFromJson(json, 'ends_at', defaultValue: null);
  }


  String get hint => _hint ?? '';

  set hint(String value) {
    _hint = value;
  }

  bool get cancel => _cancel ?? false;

  set cancel(bool value) {
    _cancel = value;
  }

  bool get online => _online ?? false;

  set online(bool value) {
    _online = value;
  }

  double get duration => _duration  ?? 0;

  set duration(double value) {
    _duration = value;
  }

  AppointmentStatus? get status => _status ?? AppointmentStatus();

  set status(AppointmentStatus? value) {
    _status = value;
  }

  User get user => _user  ?? User();

  set user(User value) {
    _user = value;
  }

  Doctor? get doctor => _doctor ?? Doctor();

  set doctor(Doctor? value) {
    _doctor = value;
  }

  Clinic get clinic => _clinic  ?? Clinic();

  set clinic(Clinic value) {
    _clinic = value;
  }

  Patient? get patient => _patient;

  set patient(Patient? value) {
    _patient = value;
  }

  List<Tax> get taxes => _taxes ?? [];

  set taxes(List<Tax> value) {
    _taxes = value;
  }

  Address? get address => _address;

  set address(Address? value) {
    _address = value;
  }

  Coupon? get coupon => _coupon;

  set coupon(Coupon? value) {
    _coupon = value;
  }

  DateTime? get appointmentAt => _appointmentAt ;

  set appointmentAt(DateTime? value) {
    _appointmentAt = value;
  }

  DateTime ?get startAt => _startAt;

  set startAt(DateTime? value) {
    _startAt = value;
  }

  DateTime? get endsAt => _endsAt;

  set endsAt(DateTime? value) {
    _endsAt = value;
  }

  Payment? get payment => _payment;

  set payment(Payment? value) {
    _payment = value;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) {
      data['id'] = this.id;
    }
    if (this._hint != null) {
      data['hint'] = this.hint;
    }
    if (this._duration != null) {
      data['duration'] = this.duration;
    }
    if (this._cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this._online != null) {
      data['online'] = this.online;
    }
    if (this._status != null) {
      data['appointment_status_id'] = this.status!.id;
    }
    if (this._coupon != null && this._coupon?.code != null) {
      data['coupon'] = this.coupon?.toJson();
    }
    if (this._coupon != null && this._coupon?.id != null) {
      data['coupon_id'] = this.coupon?.id;
    }
    if (this._taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this._user != null) {
      data['user_id'] = this.user.id;
    }
    if (this._address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this._doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    if (this._clinic != null) {
      data['clinic'] = this.clinic.toJson();
    }
    if (this._patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this._payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this._appointmentAt != null) {
      data['appointment_at'] = appointmentAt!.toUtc().toString();
    }
    if (this._startAt != null) {
      data['start_at'] = startAt!.toUtc().toString();
    }
    if (this._endsAt != null) {
      data['ends_at'] = endsAt!.toUtc().toString();
    }
    return data;
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    total += getCouponValue();
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

  double getCouponValue() {
    double total = getSubtotal();
    if (!(coupon?.hasData ?? false)) {
      return 0;
    } else {
      if (coupon!.discountType == 'percent') {
        return -(total * coupon!.discount / 100);
      } else {
        return -coupon!.discount;
      }
    }
  }

  double getSubtotal() {
    double total = 0.0;
    total = doctor!.getPrice;
    return total;
  }

  bool get canAppointmentAtClinic {
    return this.doctor!.enableAtClinic;
  }

  bool get canOnlineConsultation{
    return this.doctor!.enableOnlineConsultation;
  }

  bool get canAppointmentAtCustomerAddress {
    return this.doctor!.enableAtCustomerAddress;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Appointment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hint == other.hint &&
          cancel == other.cancel &&
          online == other.online &&
          duration == other.duration &&
          status == other.status &&
          user == other.user &&
          doctor == other.doctor &&
          clinic == other.clinic &&
          patient == other.patient &&
          taxes == other.taxes &&
          address == other.address &&
          coupon == other.coupon &&
          appointmentAt == other.appointmentAt &&
          startAt == other.startAt &&
          endsAt == other.endsAt &&
          payment == other.payment;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      online.hashCode ^
      duration.hashCode ^
      status.hashCode ^
      user.hashCode ^
      doctor.hashCode ^
      clinic.hashCode ^
      patient.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      appointmentAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode;
}
