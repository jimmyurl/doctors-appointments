import 'doctor_model.dart';
import 'parents/model.dart';

class Favorite extends Model {

  Doctor? _doctor;
  String? _userId;

  Favorite({Doctor? doctor, String? userId}) {
    _doctor = doctor;
    _userId = userId;
  }

  Favorite.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    _doctor = objectFromJson(json, 'doctor', (v) => Doctor.fromJson(v));
    _userId = stringFromJson(json, 'user_id');
  }

  String get userId => _userId ?? '';

  set userId(String value) {
    _userId = value;
  }

  Doctor get doctor => _doctor ?? Doctor();

  set doctor(Doctor value) {
    _doctor = value;
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["doctor_id"] = doctor!.id;
    map["user_id"] = userId;
    return map;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Favorite &&
          runtimeType == other.runtimeType &&
          _doctor == other._doctor &&
          _userId == other._userId;

  @override
  int get hashCode =>
      super.hashCode ^ _doctor.hashCode ^ _userId.hashCode;


}
