import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';
import 'category_model.dart';
import 'form_model.dart';
import 'pharmacy_model.dart';

class Medicine extends Model {
  String? _name;
  String? _description;
  String? _storageConditions;
  String? _strength;
  String? _genericName;
  String? _manufacturer;
  List<Media>? _images;
  int? _stockQuantity;
  double? _price;
  double? _discountPrice;
  String? _quantityUnit;
  bool? _featured;
  List<Category>? _categories;
  List<Category>? _subCategories;
  List<Form>? _forms;
  Pharmacy? _pharmacy;

  Medicine({
    String? id,
    String? name,
    String? description,
    String? storageConditions,
    String? strength,
    String? genericName,
    String? manufacturer,
    List<Media>? images,
    int? stockQuantity,
    double? price,
    double? discountPrice,
    String? quantityUnit,
    bool? featured,
    List<Category>? categories,
    List<Category>? subCategories,
    List<Form>? forms,
    Pharmacy? pharmacy,
  }) {
    this.id = id;
    _name = name;
    _description = description;
    _storageConditions = storageConditions;
    _strength = strength;
    _genericName = genericName;
    _manufacturer = manufacturer;
    _images = images;
    _stockQuantity = stockQuantity;
    _price = price;
    _discountPrice = discountPrice;
    _quantityUnit = quantityUnit;
    _featured = featured;
    _categories = categories;
    _subCategories = subCategories;
    _forms = forms;
    _pharmacy = pharmacy;
  }

  Medicine.fromJson(Map<String, dynamic>? json) {
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    storageConditions = transStringFromJson(json, 'storage_conditions');
    strength = transStringFromJson(json, 'strength');
    genericName = transStringFromJson(json, 'generic_name');
    manufacturer = transStringFromJson(json, 'manufacturer');
    images = mediaListFromJson(json, 'images');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    stockQuantity = intFromJson(json, 'stock_quantity');
    quantityUnit = transStringFromJson(json, 'quantity_unit');
    featured = boolFromJson(json, 'featured');
    categories = listFromJson<Category>(json, 'categories', (value) => Category.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    forms = listFromJson<Form>(json, 'forms', (value) => Form.fromJson(value));
    pharmacy = objectFromJson(json, 'pharmacy', (value) => Pharmacy.fromJson(value));
    super.fromJson(json);
  }

  List<Category> get categories => _categories ?? [];

  set categories(List<Category>? value) {
    _categories = value;
  }

  List<Category> get subCategories => _subCategories ?? [];

  set subCategories(List<Category>? value) {
    _subCategories = value;
  }

  List<Form> get forms => _forms ?? [];

  set forms(List<Form>? value) {
    _forms = value;
  }

  String get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }

  String get genericName => _genericName ?? '';

  set genericName(String? value) {
    _genericName = value;
  }

  String get manufacturer => _manufacturer ?? '';

  set manufacturer(String? value) {
    _manufacturer = value;
  }
  int get stockQuantity => _stockQuantity ?? 0;

  set stockQuantity(int? value) {
    _stockQuantity = value;
  }

  String get storageConditions => _storageConditions ?? '';

  set storageConditions(String? value) {
    _storageConditions = value;
  }

  String get strength => _strength ?? '';

  set strength(String? value) {
    _strength = value;
  }

  double get discountPrice => _discountPrice ?? 0;

  set discountPrice(double? value) {
    _discountPrice = value;
  }

  bool get featured => _featured ?? false;

  set featured(bool? value) {
    _featured = value;
  }

  String get firstImageIcon => this.images.first.icon;

  String get firstImageThumb => this.images.first.thumb;

  String get firstImageUrl => this.images.first.url;

  /*
  * Get discount price
  * */
  double get getOldPrice {
    return (_discountPrice ?? 0) > 0 ? price : 0;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double get getPrice {
    return (_discountPrice ?? 0) > 0 ? discountPrice : price;
  }

  @override
  bool get hasData {
    return super.hasData && _name != null && _description != null ;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ pharmacy.hashCode ^ categories.hashCode ^ subCategories.hashCode ;

  List<Media> get images => _images ?? [];

  set images(List<Media>? value) {
    _images = value;
  }

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  double get price => _price ?? 0;

  set price(double? value) {
    _price = value;
  }

  String get quantityUnit => _quantityUnit ?? '';

  set quantityUnit(String? value) {
    _quantityUnit = value;
  }

  Pharmacy get pharmacy => _pharmacy ?? Pharmacy();

  set pharmacy(Pharmacy? value) {
    _pharmacy = value;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Medicine &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          genericName == other.genericName &&
          manufacturer == other.manufacturer &&
          description == other.description &&
          storageConditions == other.storageConditions &&
          strength == other.strength &&
          categories == other.categories &&
          subCategories == other.subCategories &&
          forms == other.forms &&
          pharmacy == other.pharmacy;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) data['id'] = this.id;
    if (_name != null) data['name'] = this.name;
    if (_genericName != null) data['generic_name'] = this.genericName;
    if (_manufacturer != null) data['manufacturer'] = this.manufacturer;
    if (_description != null) data['description'] = this.description;
    if (_storageConditions != null) data['storage_conditions'] = this.storageConditions;
    if (_strength != null) data['strength'] = this.strength;
    if (_price != null) data['price'] = this.price;
    if (_discountPrice != null) data['discount_price'] = this.discountPrice;
    if (_stockQuantity != null) data['stock_quantity'] = this.stockQuantity;
    if (_quantityUnit != null && quantityUnit != 'null') data['quantity_unit'] = this.quantityUnit;
    if (_featured != null) data['featured'] = this.featured;
    if (_categories != null) {
      data['categories'] = this.categories.map((v) => v.id).toList();
    }
    if (_images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (_subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (_forms != null) {
      data['forms'] = this.forms.map((v) => v.toJson()).toList();
    }
    if (_pharmacy != null && this.pharmacy.hasData) {
      data['store_id'] = this.pharmacy.id;
    }
    return data;
  }
}
