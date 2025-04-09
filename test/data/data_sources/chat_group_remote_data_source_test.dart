import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/data_sources/remote/chat_group_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';

import '../../mock/mock_services.dart';

void main(){

  late MockHttpClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;
  late ApiService apiService;
  late ChatGroupRemoteDataSource remoteDataSource;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final testDir = Directory.current;
    Hive.init(p.join(testDir.path, 'test_hive_data'));
    await Hive.openBox('SETTINGS');
  });

  setUp((){
    mockHttpClient = MockHttpClient();
    mockTokenProvider = MockTokenProvider();
    apiService = ApiService(client: mockHttpClient, tokenProvider: mockTokenProvider);
    remoteDataSource = ChatGroupRemoteDataSourceImpl(apiService);
  });
  
  group('ChatGroupRemoteDataSource', (){

    group('MyGroups', (){
      
      test('returns MyChatGroupsModel when my group is fetched with status code 200', ()async{
        final mockToken = 'mock_token';
        const mockJson =  '''[
        {
          "_id": "67d26664ecde14f2bf1a0c3b",
          "name": "FLUTTER",
          "updatedAt": "2025-03-29T07:20:18.806Z"
        },
        {
          "_id": "67e383a7ffa889ac08ec9f89",
          "name": "Flutter",
          "updatedAt": "2025-03-28T15:48:13.373Z"
        }
      ]
''';
        when(()=> mockTokenProvider.getToken()).thenAnswer((_)async=> mockToken);

        when(()=>mockHttpClient.get(Uri.parse(ApiConstants.getMyGroups),headers: {
        'Authorization': 'Bearer $mockToken',
        'Content-Type': 'application/json; charset=UTF-8',
        },)).thenAnswer((_)async=> http.Response(mockJson,200));

        final myGroups = await remoteDataSource.getMyGroups();
        expect(myGroups, isA<MyChatGroupsModel>());
      });
      
      test('returns error as String when status code is not 200', ()async{
        final mockToken = 'mock_token';
        when(()=> mockTokenProvider.getToken()).thenAnswer((_)async=> mockToken);

        when(() => mockHttpClient.get(
          Uri.parse(ApiConstants.getMyGroups),
          headers: {
            'Authorization': 'Bearer $mockToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));
        
        expect(()=>remoteDataSource.getMyGroups(), throwsA(isA<String>()));
      });
    });

    group('createGroup',(){
    group('groupDetails', (){
        test('returns ChatGroupModel when group is fetched with status code 200', ()async{
          final mockToken = 'mock_token';
          const mockJson =  '''{
    "_id": "67d264b4ecde14f2bf1a0c31",
    "name": "SUgam",
    "members": [
        {
            "_id": "67d01b3646ee9defcea5e295",
            "name": "Sugam",
            "email": "sugam12@gmail.com"
        }
    ],
    "messages": [
        "67d2a20c91d39d42d1d1cbda",
        "67d2a2da00b0b92d6cb72d4a",
        "67de4d10a04cae42d372fe98",
        "67e23eafe7b5b57a17c3bb1a",
        "67e2467060cda9ba4a079662"
    ],
    "createdAt": "2025-03-13T04:53:08.752Z",
    "updatedAt": "2025-03-25T06:00:16.979Z",
    "__v": 37,
    "admins": []
}
''';
          when(()=> mockTokenProvider.getToken()).thenAnswer((_)async=> mockToken);

          when(()=>mockHttpClient.get(Uri.parse('${ApiConstants.getGroup}/67d264b4ecde14f2bf1a0c31'),headers: {
            'Authorization': 'Bearer $mockToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },)).thenAnswer((_)async=> http.Response(mockJson,200));

          final group = await remoteDataSource.getGroup('67d264b4ecde14f2bf1a0c31');
          expect(group, isA<ChatGroupModel>());
        });

        test('returns error as String when status code is not 200', ()async{
          final mockToken = 'mock_token';
          when(()=> mockTokenProvider.getToken()).thenAnswer((_)async=> mockToken);

          when(() => mockHttpClient.get(
            Uri.parse(ApiConstants.getGroup),
            headers: {
              'Authorization': 'Bearer $mockToken',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          )).thenAnswer((_) async => http.Response('Unauthorized', 401));

          expect(()=>remoteDataSource.getGroup('67d264b4ecde14f2bf1a0c31'), throwsA(isA<Exception>()));
        });
      });
      test('return true if group is created ie status code 200',()async{
        const mockToken = 'mock_token';
        const mockJson = '''
        {
        "_id": "2025521aa",
        "name": "SUGAM"
        }
        ''';

        when(()=>mockTokenProvider.getToken()).thenAnswer((_)async=>mockToken);
        when(() => mockHttpClient.post(
          Uri.parse(ApiConstants.createGroup),
          headers: {
            'Authorization': 'Bearer $mockToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
           body: jsonEncode({
             'name': 'SUGAM',
             'memberEmails': ['sugam@gmail.com']
           })
        )).thenAnswer((_) async => http.Response(mockJson, 200));

        final bool isCreated = await remoteDataSource.createGroup('SUGAM', ['sugam@gmail.com']);
        expect(isCreated, true);
      });
      test('Throws exception if group is not created ie status code is not 200',()async{
        const mockToken = 'mock_token';

        when(()=>mockTokenProvider.getToken()).thenAnswer((_)async=>mockToken);
        when(() => mockHttpClient.post(
          Uri.parse(ApiConstants.createGroup),
          headers: {
            'Authorization': 'Bearer $mockToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
           body: jsonEncode({
             'name': 'SUGAM',
             'memberEmails': ['sugam@gmail.com']
           })
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(()=> remoteDataSource.createGroup('SUGAM',['sugam@gmail.com']),throwsA(isA<Exception>()));
      });
    });
    
  });

  tearDownAll(() async {
    await Hive.box('SETTINGS').close();
    await Directory(p.join(Directory.current.path, 'test_hive_data')).delete(recursive: true);
  });
}