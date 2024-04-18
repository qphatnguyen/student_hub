class TechStackModel {
  final int _id;
  final String _name;

  TechStackModel(this._id, this._name);

  static List<TechStackModel> fromResponse(List<dynamic> techStacksReponse) {
    return techStacksReponse
        .map((element) =>
            TechStackModel(element['id'] as int, element['name'] as String))
        .toList();
  }

  factory TechStackModel.fromJson(Map<String, dynamic> json) {
    return TechStackModel(
      json['id'],
      json['name'],
    );
  }
  // getter
  int get id => _id;
  String get name => _name;

  @override
  String toString() => _name;
}
