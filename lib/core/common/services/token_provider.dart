import 'package:hive/hive.dart';

abstract class TokenProvider {
  Future<String?> getToken();
}

class HiveTokenProvider implements TokenProvider {
  @override
  Future<String?> getToken() async {
    return await Hive.box('SETTINGS').get('token');
  }
}