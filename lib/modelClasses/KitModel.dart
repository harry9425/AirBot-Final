class KitModel {
  late String _key;
  late String _name;
  late String _dp;
  late String _content;

  String get key => _key;
  set key(String key) => _key = key;

  String get content => _content;
  set content(String content) => _content = content;

  String get name => _name;
  set name(String name) => _name = name;

  String get dp => _dp;
  set dp(String dp) => _dp = dp;

  KitModel.empty();

  KitModel(this._key,this._name, this._dp,this._content);

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
      'dp': dp,
      'content':content,
    };
  }
}
