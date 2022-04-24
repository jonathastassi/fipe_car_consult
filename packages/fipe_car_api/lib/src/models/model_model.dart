class ModelModel {
  const ModelModel({
    required this.id,
    required this.name,
  });

  factory ModelModel.fromJson(Map<String, dynamic> map) {
    return ModelModel(
      id: map['codigo'].toString(),
      name: map['nome'] ?? '',
    );
  }

  final String id;
  final String name;
}
