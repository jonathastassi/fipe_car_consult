import 'package:fipe_car_api/fipe_car_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpResponse extends Mock implements http.Response {}

class FakeUri extends Mock implements Uri {}

void main() {
  group('FipeCarApiClient', () {
    const String baseUrl = 'parallelum.com.br';

    late FipeCarApiClient fipeCarApiClient;
    late http.Client mockHttpClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      mockHttpClient = MockHttpClient();
      fipeCarApiClient = FipeCarApiClient(
        httpClient: mockHttpClient,
      );
    });

    test('Should be created wihtou params', () {
      expect(FipeCarApiClient(), isNotNull);
    });

    test('getBrands should return a brand model list', () async {
      final response = MockHttpResponse();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(brandsResponse);

      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);
      final brands = await fipeCarApiClient.getBrands();

      expect(brands.length, 3);
      expect(
          brands[0],
          isA<BrandModel>()
              .having((e) => e.id, 'Id', '1')
              .having((e) => e.name, 'Name', 'Acura'));

      verify(() => mockHttpClient
          .get(Uri.https(baseUrl, '/fipe/api/v1/carros/marcas'))).called(1);
    });

    test('getModels should return a model list', () async {
      final response = MockHttpResponse();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(modelsResponse);

      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);
      final models = await fipeCarApiClient.getModels("anyId");

      expect(models.length, 3);
      expect(
          models[0],
          isA<ModelModel>()
              .having((e) => e.id, 'Id', '655')
              .having((e) => e.name, 'Name', 'Aerostar Mini-Van 3.8'));

      verify(() => mockHttpClient.get(
              Uri.https(baseUrl, '/fipe/api/v1/carros/marcas/anyId/modelos')))
          .called(1);
    });

    test('getYears should return a year list', () async {
      final response = MockHttpResponse();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(yearsResponse);

      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);
      final years = await fipeCarApiClient.getYears("anyId", "anyModelId");

      expect(years.length, 2);
      expect(
          years[0],
          isA<YearModel>()
              .having((e) => e.id, 'Id', '2007-1')
              .having((e) => e.name, 'Name', '2007 Gasolina'));

      verify(() => mockHttpClient.get(Uri.https(baseUrl,
              '/fipe/api/v1/carros/marcas/anyId/modelos/anyModelId/anos')))
          .called(1);
    });

    test('getCarData should return a car data', () async {
      final response = MockHttpResponse();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(carDataResponse);

      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);
      final carData =
          await fipeCarApiClient.getCarData("anyId", "anyModelId", "anyYearId");

      expect(
        carData,
        isA<CarDataModel>()
            .having((e) => e.price, 'Id', r'R$ 27.849,00')
            .having((e) => e.brand, 'brand', 'Ford')
            .having((e) => e.model, 'model',
                'EcoSport XLS FREESTYLE 1.6 Flex 8V 5p')
            .having((e) => e.year, 'year', '2006')
            .having((e) => e.fuelType, 'fuelType', 'Gasolina')
            .having((e) => e.fipeCode, 'fipeCode', '003303-0')
            .having((e) => e.monthRef, 'monthRef', 'abril de 2022 '),
      );

      verify(() => mockHttpClient.get(Uri.https(baseUrl,
              '/fipe/api/v1/carros/marcas/anyId/modelos/anyModelId/anos/anyYearId')))
          .called(1);
    });
  });
}

const String brandsResponse = '''
[
  {
    "nome": "Acura",
    "codigo": "1"
  },
  {
    "nome": "Agrale",
    "codigo": "2"
  },
  {
    "nome": "Alfa Romeo",
    "codigo": "3"
  }
]
''';

const String modelsResponse = '''
{
  "modelos": [
    {
      "nome": "Aerostar Mini-Van 3.8",
      "codigo": 655
    },
    {
      "nome": "Aspire 1.3",
      "codigo": 656
    },
    {
      "nome": "Belina GL 1.8 / 1.6",
      "codigo": 657
    }
  ]
}
''';

const String yearsResponse = '''
[
  {
    "nome": "2007 Gasolina",
    "codigo": "2007-1"
  },
  {
    "nome": "2006 Gasolina",
    "codigo": "2006-1"
  }
]
''';

const String carDataResponse = r'''
{
  "Valor": "R$ 27.849,00",
  "Marca": "Ford",
  "Modelo": "EcoSport XLS FREESTYLE 1.6 Flex 8V 5p",
  "AnoModelo": 2006,
  "Combustivel": "Gasolina",
  "CodigoFipe": "003303-0",
  "MesReferencia": "abril de 2022 ",
  "TipoVeiculo": 1,
  "SiglaCombustivel": "G"
}
''';
