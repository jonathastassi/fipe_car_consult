import 'dart:convert';

import 'package:fipe_car_api/src/fipe_car_api_exceptions.dart';
import 'package:fipe_car_api/src/models/models.dart';
import 'package:http/http.dart' as http;

class FipeCarApiClient {
  FipeCarApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static const String baseUrl = 'parallelum.com.br';

  Future<List<BrandModel>> getBrands() async {
    try {
      http.Response response = await _httpClient
          .get(Uri.https(baseUrl, '/fipe/api/v1/carros/marcas'));

      if (response.statusCode != 200) {
        throw GetBrandsFailure();
      }

      final brands = json.decode(response.body) as List;

      return brands.map((brand) => BrandModel.fromJson(brand)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<ModelModel>> getModels(String brandId) async {
    try {
      http.Response response = await _httpClient.get(
          Uri.https(baseUrl, '/fipe/api/v1/carros/marcas/$brandId/modelos'));

      if (response.statusCode == 404) {
        throw GetModelsNotFoundFailure();
      }

      if (response.statusCode != 200) {
        throw GetModelsFailure();
      }

      final models = json.decode(response.body)["modelos"] as List;

      return models.map((model) => ModelModel.fromJson(model)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<YearModel>> getYears(String brandId, String modelId) async {
    try {
      http.Response response = await _httpClient.get(Uri.https(baseUrl,
          '/fipe/api/v1/carros/marcas/$brandId/modelos/$modelId/anos'));

      if (response.statusCode == 404) {
        throw GetYearsNotFoundFailure();
      }

      if (response.statusCode != 200) {
        throw GetYearsFailure();
      }

      final years = json.decode(response.body) as List;

      return years.map((year) => YearModel.fromJson(year)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<CarDataModel> getCarData(
      String brandId, String modelId, String yearId) async {
    try {
      http.Response response = await _httpClient.get(Uri.https(baseUrl,
          '/fipe/api/v1/carros/marcas/$brandId/modelos/$modelId/anos/$yearId'));

      if (response.statusCode == 404) {
        throw GetCarDataNotFoundFailure();
      }

      if (response.statusCode != 200) {
        throw GetCarDataFailure();
      }

      final carData = json.decode(response.body) as Map<String, dynamic>;

      return CarDataModel.fromJson(carData);
    } catch (_) {
      rethrow;
    }
  }
}
