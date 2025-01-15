import '../../common/uuid.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Patient extends Model {

  String? _user_id;
  String? _first_name;
  String? _last_name;
  List<Media>? _images;
  String? _phone_number;
  String? _mobile_number;
  String? _age;
  String? _gender;
  String? _weight;
  String? _height;
  String? _medical_history;
  String? _notes;
  int? _total_appointments;

  Patient({String? user_id, String? first_name, String? last_name, List<Media>? images, String? phone_number, String? mobile_number, String? age, String? gender, String? weight, String? height,String? medical_history, String? notes,  int? total_appointments,}){
    this._user_id = user_id;
    this._first_name = first_name;
    this._last_name = last_name;
    this._images = images;
    this._phone_number = phone_number;
    this._mobile_number = mobile_number;
    this._age = age;
    this._gender = gender;
    this._weight = weight;
    this._height = height;
    this._medical_history = medical_history;
    this._notes = notes;
    this._total_appointments = total_appointments;
  }

  Patient.fromJson(Map<String, dynamic>? json) {
    _user_id = stringFromJson(json, 'user_id');
    _first_name = transStringFromJson(json, 'first_name');
    _last_name = transStringFromJson(json, 'last_name');
    _images = mediaListFromJson(json, 'images');
    _phone_number = stringFromJson(json,'phone_number');
    _mobile_number = stringFromJson(json,'mobile_number');
    _age = stringFromJson(json,'age');
    _gender = stringFromJson(json,'gender');
    _weight = stringFromJson(json,'weight');
    _height = stringFromJson(json,'height');
    _medical_history = stringFromJson(json,'medical_history');
    _notes = stringFromJson(json,'notes');
    _total_appointments = intFromJson(json,'total_appointments');

    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) data['id'] = this.id;
    if (_user_id != null) data['user_id'] = this.user_id;
    if (_first_name != null) data['first_name'] = this.first_name;
    if (_last_name != null) data['last_name'] = this.last_name;
    if (this._images != null) {
      data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    if (this._phone_number != null) data['phone_number'] = this.phone_number;
    if (this._mobile_number != null) data['mobile_number'] = this.mobile_number;
    if (this._age != null) data['age'] = this.age;
    if (this._gender != null) data['gender'] = this.gender;
    if (this._weight != null) data['weight'] = this.weight;
    if (this._height != null) data['height'] = this.height;
    if (this._medical_history != null) data['medical_history'] = this.medical_history;
    if (this._notes != null) data['notes'] = this.notes;
    if (this._total_appointments != null) data['totalAppointments'] = this.total_appointments;
    return data;
  }

  String get firstImageUrl => this.images.first.url ?? '';

  String get firstImageThumb => this.images.first.thumb ?? '';

  String get firstImageIcon => this.images.first.icon ?? '';


  @override
  bool get hasData {
    return id != '' && first_name != null && last_name != null;
  }


  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Patient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user_id == other.user_id &&
          first_name == other.first_name &&
          last_name == other.last_name &&
          phone_number == other.phone_number &&
          mobile_number == other.mobile_number &&
          age == other.age &&
          gender == other.gender &&
          weight == other.weight &&
          height == other.height &&
          total_appointments == other.total_appointments ;


  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      user_id.hashCode ^
      first_name.hashCode ^
      last_name.hashCode ^
      phone_number.hashCode ^
      mobile_number.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      total_appointments.hashCode ;




  String get user_id => _user_id ?? '';

  set user_id(String value) {
    _user_id = value;
  }


  String? get first_name => _first_name;

  set first_name(String? value) {
    _first_name = value;
  }

  String? get last_name => _last_name;

  set last_name(String? value) {
    _last_name = value;
  }

  List<Media> get images => _images ?? [];

  set images(List<Media> value) {
    _images = value;
  }

  String get phone_number => _phone_number ?? '';

  set phone_number(String value) {
    _phone_number = value;
  }

  String get mobile_number => _mobile_number ?? '';

  set mobile_number(String value) {
    _mobile_number = value;
  }

  String get age => _age ?? '';

  set age(String value) {
    _age = value;
  }

  String get gender => _gender ?? '';

  set gender(String value) {
    _gender = value;
  }

  String get weight => _weight ?? '';

  set weight(String value) {
    _weight = value;
  }

  String get height => _height ?? '';

  set height(String value) {
    _height = value;
  }

  String? get medical_history => _medical_history;

  set medical_history(String? value) {
    _medical_history = value;
  }

  String? get notes => _notes;

  set notes(String? value) {
    _notes = value;
  }

  int get total_appointments => _total_appointments ?? 0;

  set total_appointments(int value) {
    _total_appointments = value;
  }
}
