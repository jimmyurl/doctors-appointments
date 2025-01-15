/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'parents/model.dart';

class AvailabilityHour extends Model {

  String? _day;
  String? _startAt;
  String? _endAt;
  String? _data;


  AvailabilityHour({String? id, String? day, String? startAt, String? endAt, String? data}) {
    _day = day;
    _startAt = startAt;
    _endAt = endAt;
    _data = data;
    this.id = id;
  }




  AvailabilityHour.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    day = stringFromJson(json, 'day');
    startAt = stringFromJson(json, 'start_at');
    endAt = stringFromJson(json, 'end_at');
    data = transStringFromJson(json, 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['data'] = this.data;
    return data;
  }


  String get day => _day  ?? '';

  set day(String value) {
    _day = value;
  }

  String get startAt => _startAt  ?? '';

  set startAt(String value) {
    _startAt = value;
  }

  String get endAt => _endAt  ?? '';

  set endAt(String value) {
    _endAt = value;
  }

  String get data => _data  ?? '';

  set data(String value) {
    _data = value;
  }
}
