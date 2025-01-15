import '../../app/models/parents/model.dart';

class OrderStatus extends Model {
  String? _status;
  int? _order;

  OrderStatus({String? id, String? status, int? order}) {
    this.id = id;
    this._status = status;
    this._order = order;
  }

  OrderStatus.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    status = transStringFromJson(json, 'status');
    order = intFromJson(json, 'order');
  }

  int get order => _order ?? 0;

  set order(int? value) {
    _order = value;
  }

  String get status => _status ?? '';

  set status(String? value) {
    _status = value;
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
