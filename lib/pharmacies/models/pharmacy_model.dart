/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import '../../app/models/address_model.dart';
import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';
import '../../app/models/tax_model.dart';
import '../../app/models/user_model.dart';
import 'pharmacy_type_model.dart';

class Pharmacy extends Model {
  String? _name;

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  String? _description;

  String get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }

  List<Media>? _images;

  List<Media> get images => _images ?? [];

  set images(List<Media>? value) {
    _images = value;
  }

  String? _phoneNumber;

  String get phoneNumber => _phoneNumber ?? '';

  set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  String? _mobileNumber;

  String get mobileNumber => _mobileNumber ?? '';

  set mobileNumber(String? value) {
    _mobileNumber = value;
  }

  PharmacyType? _type;

  PharmacyType? get type => _type;

  set type(PharmacyType? value) {
    _type = value;
  }

  double? _availabilityRange;

  double get availabilityRange => _availabilityRange ?? 0.0;

  set availabilityRange(double? value) {
    _availabilityRange = value;
  }

  bool? _available;

  bool get available => _available ?? false;

  set available(bool? value) {
    _available = value;
  }

  double? _distance;

  double get distance => _distance ?? 0.0;

  set distance(double? value) {
    _distance = value;
  }

  bool? _featured;

  bool get featured => _featured ?? false;

  set featured(bool? value) {
    _featured = value;
  }

  List<Address>? _addresses;

  List<Address> get addresses => _addresses ?? [];

  set addresses(List<Address>? value) {
    _addresses = value;
  }

  List<Tax>? _taxes;

  List<Tax> get taxes => _taxes ?? [];

  set taxes(List<Tax>? value) {
    _taxes = value;
  }

  List<User>? _employees;

  List<User> get employees => _employees ?? [];

  set employees(List<User>? value) {
    _employees = value;
  }

  bool? _verified;

  bool get verified => _verified ?? false;

  set verified(bool? value) {
    _verified = value;
  }

  Pharmacy(
      {String? id,
      String? name,
      String? description,
      List<Media>? images,
      String? phoneNumber,
      String? mobileNumber,
      PharmacyType? type,
      double? availabilityRange,
      bool? available,
      double? distance,
      bool? featured,
      List<Address>? addresses,
      List<User>? employees,
      bool? verified}) {
    this.id = id;
    this._name = name;
    this._description = description;
    this._images = images;
    this._phoneNumber = phoneNumber;
    this._mobileNumber = mobileNumber;
    this._type = type;
    this._availabilityRange = availabilityRange;
    this._available = available;
    this._distance = distance;
    this._featured = featured;
    this._addresses = addresses;
    this._employees = employees;
    this._verified = verified;
  }

  Pharmacy.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _name = transStringFromJson(json, 'name');
    _description = transStringFromJson(json, 'description');
    _images = mediaListFromJson(json, 'images');
    _type = objectFromJson(json, 'pharmacy_type', (v) => PharmacyType.fromJson(v));
    _phoneNumber = stringFromJson(json, 'phone_number');
    _mobileNumber = stringFromJson(json, 'mobile_number');
    _type = objectFromJson(json, 'pharmacy_type', (v) => PharmacyType.fromJson(v));
    _availabilityRange = doubleFromJson(json, 'availability_range');
    _available = boolFromJson(json, 'available');
    _distance = doubleFromJson(json, 'distance');
    _featured = boolFromJson(json, 'featured');
    _addresses = listFromJson(json, 'addresses', (v) => Address.fromJson(v));
    _taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    _employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    _verified = boolFromJson(json, 'verified');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['available'] = this.available;
    data['distance'] = this.distance;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['verified'] = this.verified;
    return data;
  }

  String get firstImageUrl => this.images.first.url;

  String get firstImageThumb => this.images.first.thumb;

  String get firstImageIcon => this.images.first.icon;

  String get firstAddress {
    if (this.addresses.isNotEmpty) {
      return this.addresses.first.address;
    }
    return '';
  }

  @override
  bool get hasData {
    return super.hasData && _name != null && _description != null;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Pharmacy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          type == other.type &&
          availabilityRange == other.availabilityRange &&
          available == other.available &&
          distance == other.distance &&
          featured == other.featured &&
          addresses == other.addresses &&
          verified == other.verified;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      type.hashCode ^
      availabilityRange.hashCode ^
      available.hashCode ^
      distance.hashCode ^
      featured.hashCode ^
      addresses.hashCode ^
      verified.hashCode;
}
