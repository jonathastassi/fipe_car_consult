class YearModel {
  const YearModel({
    required this.id,
    required this.name,
  });

  factory YearModel.fromJson(Map<String, dynamic> map) {
    return YearModel(
      id: map['codigo'] ?? '',
      name: map['nome'] ?? '',
    );
  }

  final String id;
  final String name;
}
