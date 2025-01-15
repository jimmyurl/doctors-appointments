import 'package:get/get.dart';

import 'availability_hour_model.dart';
import 'speciality_model.dart';
import 'clinic_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'user_model.dart';

class Doctor extends Model {
  String? _name;
  String? _description;
  List<Media>? _images;
  double? _price;
  double? _discountPrice;
  List<AvailabilityHour>? _availabilityHours;
  User? _user;
  bool? _available ;
  double? _rate;
  int? _totalReviews;
  bool? _featured ;
  bool? _enableAppointment ;
  bool? _enableAtClinic ;
  bool? _enableOnlineConsultation ;
  bool? _enableAtCustomerAddress ;
  bool? _isFavorite ;
  List<Speciality>? _specialities;
  List<Speciality>? _subSpecialities;
  Clinic? _clinic;
  String?  _sessionDuration;

  Doctor(
      {String? id,
      String? name,
      String? description,
      List<Media>? images,
      double? price,
      double? discountPrice,
      List<AvailabilityHour>? availabilityHours,
      User? user,
      bool? available,
      double? rate,
      int? totalReviews,
      bool? featured,
      bool? enableAppointment,
      bool? enableAtClinic,
      bool? enableOnlineConsultation,
      bool? enableAtCustomerAddress,
      bool? isFavorite,
      List<Speciality>? specialities,
      List<Speciality>? subSpecialities,
      Clinic? clinic,
      String? sessionDuration}) {
    this.id = id;
    _clinic = clinic;
    _subSpecialities = subSpecialities;
    _specialities = specialities;
    _isFavorite = isFavorite;
    _enableAtCustomerAddress = enableAtCustomerAddress;
    _enableOnlineConsultation = enableOnlineConsultation;
    _enableAtClinic = enableAtClinic;
    _enableAppointment = enableAppointment;
    _featured = featured;
    _totalReviews = totalReviews;
    _rate = rate;
    _available = available;
    _user = user;
    _availabilityHours = availabilityHours;
    _discountPrice = discountPrice;
    _price = price;
    _images = images;
    _description = description;
    _name = name;
    _sessionDuration = sessionDuration;
  }

  Doctor.fromJson(Map<String, dynamic>? json) {
    _name = transStringFromJson(json, 'name');
    _description = transStringFromJson(json, 'description');
    _images = mediaListFromJson(json, 'images');
    _price = doubleFromJson(json, 'price');
    _discountPrice = doubleFromJson(json, 'discount_price');
    _availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    _available = boolFromJson(json, 'available');
    _rate = doubleFromJson(json, 'rate');
    _totalReviews = intFromJson(json, 'total_reviews');
    _featured = boolFromJson(json, 'featured');
    _enableAppointment = boolFromJson(json, 'enable_appointment');
    _enableAtClinic = boolFromJson(json, 'enable_at_clinic');
    _enableOnlineConsultation = boolFromJson(json, 'enable_online_consultation');
    _enableAtCustomerAddress = boolFromJson(json, 'enable_at_customer_address');
    _isFavorite = boolFromJson(json, 'is_favorite');
    _specialities = listFromJson<Speciality>(json, 'specialities', (value) => Speciality.fromJson(value));
    _subSpecialities = listFromJson<Speciality>(json, 'sub_specialities', (value) => Speciality.fromJson(value));
    _clinic = objectFromJson(json, 'clinic', (value) => Clinic.fromJson(value));
    _user = objectFromJson(json, 'user', (value) => User.fromJson(value));
    _sessionDuration = stringFromJson(json, 'session_duration');
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) data['id'] = this.id;
    if (_name != null) data['name'] = this.name;
    if (this._description != null) data['description'] = this.description;
    if (this._price != null) data['price'] = this.price;
    if (_discountPrice != null) data['discount_price'] = this.discountPrice;
    data['available'] = this.available;
    if (_rate != null) data['rate'] = this.rate;
    if (_totalReviews != null) data['total_reviews'] = this.totalReviews;
    data['featured'] = this.featured;
    data['enable_appointment'] = this.enableAppointment;
    data['enable_at_clinic'] = this.enableAtClinic;
    data['enable_at_customer_address'] = this.enableAtCustomerAddress;
    data['enable_online_consultation'] = this.enableOnlineConsultation;
    data['is_favorite'] = this.isFavorite;
    if (this._specialities != null) {
      data['specialities'] = this.specialities.map((v) => v.id).toList();
    }
    if (this._images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this._subSpecialities != null) {
      data['sub_specialities'] = this.subSpecialities.map((v) => v.toJson()).toList();
    }
    if (this._clinic != null && this.clinic.hasData) {
      data['clinic_id'] = this.clinic.id;
    }
    if (this._user != null && this.user.hasData) {
      data['user_id'] = this.user.id;
    }
    if (this._sessionDuration != null) {
      data['session_duration'] = this._sessionDuration;
    }
    return data;
  }

  String get firstImageUrl => this.images.first.url;


  String get firstImageIcon => this.images.first.icon;


  String get firstImageThumb => this.images.first.thumb;


  @override
  bool get hasData {
    return super.hasData && _name != null && _description != null;
  }

  /*
  * Get the real price of the doctor
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double get getPrice {
    return (discountPrice) > 0 ? discountPrice : price;
  }

  /*
  * Get discount price
  * */
  double get getOldPrice {
    return (discountPrice) > 0 ? price : 0;
  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day]?.add(element.startAt + ' - ' + element.endAt);
      } else {
        result[element.day] = [element.startAt + ' - ' + element.endAt];
      }
    });
    return result;
  }
  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }
  @override
  bool operator == (dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Doctor &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          rate == other.rate &&
          available == other.available &&
          isFavorite == other.isFavorite &&
          specialities == other.specialities &&
          subSpecialities == other.subSpecialities &&
          user == other.user &&
          clinic == other.clinic;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      rate.hashCode ^
      available.hashCode ^
      clinic.hashCode ^
      user.hashCode ^
      specialities.hashCode ^
      subSpecialities.hashCode ;

  String get name => _name ?? '';

  set name(String value) {
    _name = value;
  }


  String get description => _description ?? '';

  set description(String value) {
    _description = value;
  }

  List<Media> get images => _images ?? [];

  set images(List<Media> value) {
    _images = value;
  }

  double get price => _price ?? 0;

  set price(double value) {
    _price = value;
  }

  double get discountPrice => _discountPrice ?? 0;

  set discountPrice(double value) {
    _discountPrice = value;
  }

  List<AvailabilityHour> get availabilityHours => _availabilityHours ?? [];

  set availabilityHours(List<AvailabilityHour> value) {
    _availabilityHours = value;
  }

  User get user => _user ?? User();

  set user(User value) {
    _user = value;
  }

  bool get available => _available ?? false;

  set available(bool value) {
    _available = value;
  }

  double get rate => _rate ?? 0;

  set rate(double value) {
    _rate = value;
  }

  int get totalReviews => _totalReviews ?? 0;

  set totalReviews(int value) {
    _totalReviews = value;
  }

  bool get featured => _featured ?? false;

  set featured(bool value) {
    _featured = value;
  }

  bool get enableAppointment => _enableAppointment ?? false;

  set enableAppointment(bool value) {
    _enableAppointment = value;
  }

  bool get enableAtClinic => _enableAtClinic ?? false;

  set enableAtClinic(bool value) {
    _enableAtClinic = value;
  }

  bool get enableOnlineConsultation => _enableOnlineConsultation ?? false;

  set enableOnlineConsultation(bool value) {
    _enableOnlineConsultation = value;
  }

  bool get enableAtCustomerAddress => _enableAtCustomerAddress ?? false;

  set enableAtCustomerAddress(bool value) {
    _enableAtCustomerAddress = value;
  }

  bool? get isFavorite => _isFavorite;

  set isFavorite(bool? value) {
    _isFavorite = value;
  }

  List<Speciality> get specialities => _specialities ?? [];

  set specialities(List<Speciality> value) {
    _specialities = value;
  }

  List<Speciality> get subSpecialities => _subSpecialities ?? [];

  set subSpecialities(List<Speciality> value) {
    _subSpecialities = value;
  }

  Clinic get clinic => _clinic ?? Clinic();

  set clinic(Clinic value) {
    _clinic = value;
  }

  String? get sessionDuration => _sessionDuration;

  set sessionDuration(String? value) {
    sessionDuration = value;
  }
}
