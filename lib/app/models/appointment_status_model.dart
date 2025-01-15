import 'parents/model.dart';

class AppointmentStatus extends Model {
  String? _status;
  int? _order;

  String get status => _status ?? '';

  set status(String? value) {
    _status = value;
  }

  int get order => _order ?? 0;

  set order(int? value) {
    _order = value;
  }


  AppointmentStatus({String? id, String? status, int? order}) {
    _order = order;
    _status = status;
    this.id = id;
  }
  AppointmentStatus.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    status = transStringFromJson(json, 'status');
    order = intFromJson(json, 'order');
  }



  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['order'] = this.order;
    return data;
  }
}
