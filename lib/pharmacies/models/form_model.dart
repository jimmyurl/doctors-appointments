import 'package:flutter/material.dart';

import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';
import 'medicine_model.dart';

class Form extends Model {
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

  Color? _color;

  Color get color => _color ?? Colors.white24;

  set color(Color? value) {
    _color = value;
  }

  Media? _image;

  Media get image => _image ?? Media();

  set image(Media? value) {
    _image = value;
  }

  bool? _featured;

  bool get featured => _featured ?? false;

  set featured(bool? value) {
    _featured = value;
  }


  List<Medicine>? _medicines;

  List<Medicine> get medicines => _medicines ?? [];

  set medicines(List<Medicine>? value) {
    _medicines = value;
  }

  Form({String? id, String? name, String? description, Color? color, Media? image, bool? featured, List<Medicine>? medicines}) {
    this.id = id;
    _medicines = medicines;
    _featured = featured;
    _image = image;
    _color = color;
    _description = description;
    _name = name;
  }

  Form.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');
    medicines = listFromJsonArray(json, ['medicines', 'featured_medicines'], (v) => Medicine.fromJson(v));
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
          other is Form &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          medicines == other.medicines;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ medicines.hashCode;
}
