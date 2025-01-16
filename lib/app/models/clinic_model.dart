/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'package:afridocx/app/models/user_model.dart';

import 'address_model.dart';
import 'availability_hour_model.dart';
import 'clinic_level_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'tax_model.dart';

class Clinic extends Model {
  String? _id;
  String? _name;
  String? _description;
  List<Media>? _images;
  String? _phoneNumber;
  String? _mobileNumber;
  ClinicLevel? _level;
  double? _availabilityRange;
  double? _distance;
  bool? _available;
  bool? _featured;
  Address? _address;
  List<Tax>? _taxes;
  double? _rate;
  List<Review>? _reviews;
  List<User>? _employees;
  int? _totalReviews;
  bool? _verified;
  int? _total_appointments;


  Clinic(
      {String? id,
      String? name,
      String? description,
      List<Media>? images,
      String? phoneNumber,
      String? mobileNumber,
      ClinicLevel? level,
      double? availabilityRange,
      double? distance,
      bool? available,
      bool? featured,
      Address? address,
      List<Tax>? taxes,
      double? rate,
      List<Review>? reviews,
      List<User>? employees,
      int? totalReviews,
      bool? verified,
      int? total_appointments}) {
    _total_appointments = total_appointments;
    _verified = verified;
    _totalReviews = totalReviews;
    _employees = employees;
    _reviews = reviews;
    _rate = rate;
    _taxes = taxes;
    _address = address;
    _featured = featured;
    _available = available;
    _distance = distance;
    _availabilityRange = availabilityRange;
    _level = level;
    _mobileNumber = mobileNumber;
    _phoneNumber = phoneNumber;
    _images = images;
    _description = description;
    _name = name;
    this.id = id;
  }


  Clinic.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _name = transStringFromJson(json, 'name');
    _description = transStringFromJson(json, 'description');
    _images = mediaListFromJson(json, 'images');
    _phoneNumber = stringFromJson(json, 'phone_number');
    _mobileNumber = stringFromJson(json, 'mobile_number');
    _level = objectFromJson(json, 'clinic_level', (v) => ClinicLevel.fromJson(v));
    _availabilityRange = doubleFromJson(json, 'availability_range');
    _distance = doubleFromJson(json, 'distance');
    _available = boolFromJson(json, 'available');
    _featured = boolFromJson(json, 'featured');
    _address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    _taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    _employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    _rate = doubleFromJson(json, 'rate');
    _reviews = listFromJson(json, 'clinic_reviews', (v) => Review.fromJson(v));
    if (_reviews != null) {
      _totalReviews = _reviews!.isEmpty ? intFromJson(json, 'total_reviews') : _reviews!.length;
    }
    _verified = boolFromJson(json, 'verified');
    _total_appointments = intFromJson(json, 'total_appointments');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['available'] = this.available;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['clinic_level_id'] = this.level.id;
    if (this._address != null) {
      data['address'] = this.address!.toJson();
    }
    data['taxes'] = this.taxes.map((v) => v.toJson()).toList();
    data['clinic_reviews'] = this.reviews.map((v) => v.toJson()).toList();
    data['images'] = this.images.map((v) => v.toJson()).toList();
    data['featured'] = this.featured;
    data['availability_range'] = this.availabilityRange;
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['total_appointments'] = this.total_appointments;
    data['distance'] = this.distance;
    data['users'] = this.employees.map((v) => v.toJson()).toList();
    return data;
  }

  String get firstImageUrl => this.images.first.url ?? '';

  String get firstImageThumb => this.images.first.thumb ?? '';

  String get firstImageIcon => this.images.first.icon ?? '';


  @override
  bool get hasData {
    return super.hasData && _name != null && _description != null && _description != '';
  }


  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Clinic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          level == other.level &&
          availabilityRange == other.availabilityRange &&
          distance == other.distance &&
          available == other.available &&
          featured == other.featured &&
          address == other.address &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified &&
          total_appointments == other.total_appointments;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      level.hashCode ^
      availabilityRange.hashCode ^
      distance.hashCode ^
      available.hashCode ^
      featured.hashCode ^
      address.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode ^
      total_appointments.hashCode;

  String get name => _name ?? '';

  set name(String value) {
    _name = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  List<Media> get images => _images ?? [];

  set images(List<Media> value) {
    _images = value;
  }

  String get phoneNumber => _phoneNumber ?? '';

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get mobileNumber => _mobileNumber ?? '';

  set mobileNumber(String value) {
    _mobileNumber = value;
  }

  ClinicLevel get level => _level ?? ClinicLevel();

  set level(ClinicLevel value) {
    _level = value;
  }

  double get availabilityRange => _availabilityRange ?? 0;

  set availabilityRange(double value) {
    _availabilityRange = value;
  }

  double get distance => _distance ?? 0;

  set distance(double value) {
    _distance = value;
  }

  bool get available => _available ?? false;

  set available(bool value) {
    _available = value;
  }

  bool get featured => _featured ?? false;

  set featured(bool value) {
    _featured = value;
  }

  Address? get address => _address;

  set address(Address? value) {
    _address = value;
  }

  List<Tax> get taxes => _taxes ?? [];

  set taxes(List<Tax> value) {
    _taxes = value;
  }

  double get rate => _rate ?? 0;

  set rate(double value) {
    _rate = value;
  }

  List<Review> get reviews => _reviews ?? [];

  set reviews(List<Review> value) {
    _reviews = value;
  }

  List<User> get employees => _employees ?? [];

  set employees(List<User> value) {
    _employees = value;
  }

  int get totalReviews => _totalReviews ?? 0;

  set totalReviews(int value) {
    _totalReviews = value;
  }

  bool get verified => _verified ?? false;

  set verified(bool value) {
    _verified = value;
  }

  int get total_appointments => _total_appointments ?? 0;

  set total_appointments(int value) {
    _total_appointments = value;
  }
}
