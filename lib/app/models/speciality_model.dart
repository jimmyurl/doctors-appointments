import 'package:flutter/material.dart';

import 'doctor_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Speciality extends Model {
  String? _name;
  String? _description;
  Color? _color;
  Media? _image;
  bool? _featured;
  List<Speciality>? _subSpecialities;
  List<Doctor>? _doctors;


  Speciality(
      {String? id,
      String? name,
      String? description,
      Color? color,
      Media? image,
      bool? featured,
      List<Speciality>? subSpecialities,
      List<Doctor>? doctors}) {
    _name = name;
    _description = description;
    _color = color;
    _image = image;
    _featured = featured;
    _subSpecialities = subSpecialities;
    _doctors = doctors;
  }

  Speciality.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _name = transStringFromJson(json, 'name');
    _color = colorFromJson(json, 'color');
    _description = transStringFromJson(json, 'description');
    _image = mediaFromJson(json, 'image');
    _featured = boolFromJson(json, 'featured');
    _doctors = listFromJsonArray(json, ['doctors', 'featured_doctors'], (v) => Doctor.fromJson(v));
    _subSpecialities = listFromJson(json, 'sub_specialities', (v) => Speciality.fromJson(v));
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Speciality &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          subSpecialities == other.subSpecialities &&
          doctors == other.doctors;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ subSpecialities.hashCode ^ doctors.hashCode;

  String get name => _name ?? '';

  set name(String value) {
    _name = value;
  }

  String get description => _description ?? '';

  set description(String value) {
    _description = value;
  }

  Color get color => _color ?? Colors.white;

  set color(Color value) {
    _color = value;
  }

  Media get image => _image ?? Media();

  set image(Media value) {
    _image = value;
  }

  bool get featured => _featured ?? false;

  set featured(bool value) {
    _featured = value;
  }

  List<Speciality> get subSpecialities => _subSpecialities ?? [];

  set subSpecialities(List<Speciality> value) {
    _subSpecialities = value;
  }

  List<Doctor> get doctors => _doctors ?? [];

  set doctors(List<Doctor> value) {
    _doctors = value;
  }
}
