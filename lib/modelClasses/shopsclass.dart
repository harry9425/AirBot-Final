class ShopModel {
  late String _key;
  late String _coor;
  late String _location;
  late String _name;
  late String _dp;
  late String _isopen;

  String get key => _key;
  set key(String key) => _key = key;

  String get isopen => _isopen;
  set isopen(String isopen) => _isopen = isopen;

  String get location => _location;
  set location(String location) => _location = location;

  String get coor => _coor;
  set coor(String coor) => _coor = coor;

  String get name => _name;
  set name(String name) => _name = name;

  String get dp => _dp;
  set dp(String dp) => _dp = dp;

  ShopModel.empty();

  ShopModel(this._key, this._coor,this._name, this._dp,this._isopen);

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'coor': coor,
      'location': location,
      'name': name,
      'dp': dp,
      'isopen':isopen,
    };
  }
}
