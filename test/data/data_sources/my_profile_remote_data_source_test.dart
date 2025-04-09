import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/profile/data/data_sources/my_profile_remote_data_source.dart';
import 'package:taskflow/features/profile/data/models/profile_model.dart';

import '../../mock/mock_services.dart';


void main() {
  late MockHttpClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;
  late ApiService apiService;
  late MyProfileRemoteDataSourceImpl remoteDataSource;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final testDir = Directory.current;
    Hive.init(p.join(testDir.path, 'test_hive_data'));
    await Hive.openBox('SETTINGS');
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockTokenProvider = MockTokenProvider();
    apiService = ApiService(client: mockHttpClient, tokenProvider: mockTokenProvider);
    remoteDataSource = MyProfileRemoteDataSourceImpl(apiService);
  });

  group('MyProfileRemoteDataSource', () {
    test('returns ProfileModel when API call is successful (200)', () async {
      const mockToken = 'mock_token';
      const mockJson = '''
        {
          "_id": "1",
          "name": "Leanne Graham",
          "email": "Sincere@april.biz"
        }
      ''';
      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => mockToken);

      when(() => mockHttpClient.get(
        Uri.parse(ApiConstants.myProfile),
        headers: {
          'Authorization': 'Bearer $mockToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      )).thenAnswer((_) async => http.Response(mockJson, 200));

      final result = await remoteDataSource.getMyProfile();
      expect(result, isA<ProfileModel>());
      expect(result.name, 'Leanne Graham');
    });

    test('throws Exception when API call fails (e.g. 401)', () async {
      const mockToken = 'mock_token';

      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => mockToken);

      when(() => mockHttpClient.get(
        Uri.parse(ApiConstants.myProfile),
        headers: {
          'Authorization': 'Bearer $mockToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
            () => remoteDataSource.getMyProfile(),
        throwsA(isA<String>()),
      );
    });
  });

  tearDownAll(() async {
    await Hive.box('SETTINGS').close();
    await Directory(p.join(Directory.current.path, 'test_hive_data')).delete(recursive: true);
  });
}
