import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/group_actions_remote_data_source.dart';

import '../../mock/mock_services.dart';


void main() {
  late MockHttpClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;
  late ApiService apiService;
  late GroupActionsRemoteDataSource remoteDataSource;

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
    remoteDataSource = GroupActionsRemoteDataSourceImpl(apiService);
  });

  group('GroupActionsRemoteDataSource', () {
    test('Leaves group when API call is successful (200)', () async {
      const mockToken = 'mock_token';
      const mockVal = '''
        {
          "message": "Group left successfully"
        }
      ''';
      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => mockToken);

      when(() => mockHttpClient.post(
        Uri.parse(ApiConstants.leaveGroup),
        headers: {
          'Authorization': 'Bearer $mockToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'groupId': '2123aaa'}),
      )).thenAnswer((_) async => http.Response(mockVal, 200));
      await remoteDataSource.leaveGroup('2123aaa');
      verify(() => mockHttpClient.post(
          Uri.parse(ApiConstants.leaveGroup),
          headers: {
            'Authorization': 'Bearer $mockToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        body: jsonEncode({'groupId': '2123aaa'}),
      )).called(1);
    });

    test('throws Exception when API call fails (e.g. 401)', () async {
      const mockToken = 'mock_token';

      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => mockToken);

      when(() => mockHttpClient.post(
        Uri.parse(ApiConstants.leaveGroup),
        headers: {
          'Authorization': 'Bearer $mockToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {
          'groupId': '2123aaa'
        }
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
            () => remoteDataSource.leaveGroup('2123aaa'),
        throwsA(isA<String>()),
      );
    });
   });

  tearDownAll(() async {
    await Hive.box('SETTINGS').close();
    await Directory(p.join(Directory.current.path, 'test_hive_data')).delete(recursive: true);
  });
}
