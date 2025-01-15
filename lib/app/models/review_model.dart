/*
 * Copyright (c) 2020 .
 */
import 'clinic_model.dart';
import 'doctor_model.dart';
import 'parents/model.dart';
import 'user_model.dart';

class Review extends Model {
  String? _id;
  double? _rate;
  String? _review;
  DateTime? _createdAt;
  User? _user;
  Doctor? _doctor;
  Clinic? _clinic;

  Review(
      {String? id,
      double? rate,
      String? review,
      DateTime? createdAt,
      User? user,
      Doctor? doctor,
      Clinic? clinic}) {
    _clinic = clinic;
    _doctor = doctor;
    _user = user;
    _createdAt = createdAt;
    _review = review;
    _rate = rate;
    this.id = id;
  }

  Review.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _rate = doubleFromJson(json, 'rate');
    _review = stringFromJson(json, 'review');
    _createdAt = dateFromJson(json, 'created_at',
        defaultValue: DateTime.now().toLocal());
    _user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    _doctor = objectFromJson(json, 'doctor', (v) => Doctor.fromJson(v));
    _clinic = objectFromJson(json, 'clinic', (v) => Clinic.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['created_at'] = this.createdAt;
    if (this.user != null) {
      data['user_id'] = this.user!.id;
    }
    if (this.doctor != null) {
      data['doctor_id'] = this.doctor!.id;
    }
    if (this.clinic != null) {
      data['clinic_id'] = this.clinic!.id;
    }
    return data;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rate == other.rate &&
          review == other.review &&
          createdAt == other.createdAt &&
          user == other.user &&
          doctor == other.doctor &&
          clinic == other.clinic;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      rate.hashCode ^
      review.hashCode ^
      createdAt.hashCode ^
      user.hashCode ^
      doctor.hashCode ^
      clinic.hashCode;

  Clinic get clinic => _clinic ?? Clinic();

  set clinic(Clinic value) {
    _clinic = value;
  }

  Doctor get doctor => _doctor ?? Doctor();

  set doctor(Doctor value) {
    _doctor = value;
  }

  User get user => _user ?? User();

  set user(User value) {
    _user = value;
  }

  DateTime? get createdAt => _createdAt;

  set createdAt(DateTime? value) {
    _createdAt = value;
  }

  String get review => _review ?? '';

  set review(String value) {
    _review = value;
  }

  double get rate => _rate ?? 0;

  set rate(double value) {
    _rate = value;
  }
}
