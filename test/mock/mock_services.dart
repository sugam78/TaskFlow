
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/core/common/services/token_provider.dart';


class MockHttpClient extends Mock implements http.Client {}
class MockTokenProvider extends Mock implements TokenProvider {}

