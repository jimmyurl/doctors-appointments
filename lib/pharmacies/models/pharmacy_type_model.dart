/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import '../../app/models/parents/model.dart';

class PharmacyType extends Model {
  String? _name;

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  double? _commission;

  double get commission => _commission ?? 0;

  set commission(double? value) {
    _commission = value;
  }

  PharmacyType({String? id, String? name, double? commission}) {
    _commission = commission;
    _name = name;
    this.id = id;
  }

  PharmacyType.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    commission = doubleFromJson(json, 'commission');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['commission'] = this.commission;
    return data;
  }
}
