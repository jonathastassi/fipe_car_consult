class CarDataModel {
  CarDataModel({
    required this.price,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.fipeCode,
    required this.monthRef,
  });

  factory CarDataModel.fromJson(Map<String, dynamic> map) {
    return CarDataModel(
      price: map['Valor'] ?? '',
      brand: map['Marca'] ?? '',
      model: map['Modelo'] ?? '',
      year: map['AnoModelo'].toString(),
      fuelType: map['Combustivel'] ?? '',
      fipeCode: map['CodigoFipe'] ?? '',
      monthRef: map['MesReferencia'] ?? '',
    );
  }

  final String price;
  final String brand;
  final String model;
  final String year;
  final String fuelType;
  final String fipeCode;
  final String monthRef;
}
