import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:giphy_search_app/Services/giphy_api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'giphy_api_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late GiphyApiService giphyApiService;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    mockClient = MockClient();
    giphyApiService = GiphyApiService(client: mockClient);
  });

  group('GiphyApiService', () {
    test('searchGifs returns gif data when API call is successful', () async {
      final mockResponse = {
        'data': [
          {
            'images': {
              'original': {'url': 'test_url'},
            },
            'title': 'test gif',
          }
        ],
        'pagination': {'total_count': 1, 'count': 1, 'offset': 0}
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          jsonEncode(mockResponse),
          200,
        ),
      );

      final result = await giphyApiService.searchGifs('test', 1, 0);

      expect(result, mockResponse);
      verify(mockClient.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=${dotenv.env['GIPHY_API_KEY']}&q=test&limit=1&offset=0')));
    });

    test('searchGifs throws exception when API call fails', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => giphyApiService.searchGifs('test', 1, 0),
        throwsA(isA<Exception>()),
      );
    });
  });
}
