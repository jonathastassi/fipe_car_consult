import 'dart:convert';

import 'package:fipe_car_api/src/models/models.dart';
import 'package:http/http.dart' as http;

class FipeCarApiClient {
  FipeCarApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static const String baseUrl = 'parallelum.com.br';

  Future<List<BrandModel>> getBrands() async {
    http.Response response =
        await _httpClient.get(Uri.https(baseUrl, '/fipe/api/v1/carros/marcas'));

    final brands = json.decode(response.body) as List;

    return brands.map((brand) => BrandModel.fromJson(brand)).toList();
  }

  Future<List<ModelModel>> getModels(String brandId) async {
    http.Response response = await _httpClient
        .get(Uri.https(baseUrl, '/fipe/api/v1/carros/marcas/$brandId/modelos'));

    final models = json.decode(response.body)["modelos"] as List;

    return models.map((model) => ModelModel.fromJson(model)).toList();
  }

  Future<List<YearModel>> getYears(String brandId, String modelId) async {
    http.Response response = await _httpClient.get(Uri.https(
        baseUrl, '/fipe/api/v1/carros/marcas/$brandId/modelos/$modelId/anos'));

    final years = json.decode(response.body) as List;

    return years.map((year) => YearModel.fromJson(year)).toList();
  }

  Future<CarDataModel> getCarData(
      String brandId, String modelId, String yearId) async {
    http.Response response = await _httpClient.get(Uri.https(baseUrl,
        '/fipe/api/v1/carros/marcas/$brandId/modelos/$modelId/anos/$yearId'));

    final carData = json.decode(response.body) as Map<String, dynamic>;

    return CarDataModel.fromJson(carData);
  }
}
