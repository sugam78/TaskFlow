import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:taskflow/core/common/services/token_provider.dart';

class ApiService {
  final http.Client client;
  final TokenProvider tokenProvider;

  ApiService({
    required this.client,
    required this.tokenProvider,
  });

  Future<dynamic> request(
      String url,
      String method, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
        File? file,
        bool authorization = true,
      }) async {
    method = method.toUpperCase();
    http.Response? response;

    try {
      final token = authorization ? await tokenProvider.getToken() : null;

      final finalHeaders = {
        if (authorization && token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
        ...?headers,
      };

      if (file != null) {
        var request = http.MultipartRequest(method, Uri.parse(url));
        request.headers.addAll(finalHeaders);

        var fileStream = http.ByteStream(file.openRead());
        var length = await file.length();

        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: basename(file.path),
          contentType: MediaType("image", "png"),
        );

        request.files.add(multipartFile);

        var streamedResponse = await client.send(request);
        var responseData = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
          return jsonDecode(responseData);
        } else {
          final errorMessage = jsonDecode(responseData)["error"] ?? "An error occurred";
          throw Exception(errorMessage);
        }
      }

      // Regular JSON requests
      if (method == 'GET') {
        response = await client.get(Uri.parse(url), headers: finalHeaders);
      } else if (method == 'POST') {
        response = await client.post(Uri.parse(url), headers: finalHeaders, body: jsonEncode(body));
      } else if (method == 'PUT') {
        response = await client.put(Uri.parse(url), headers: finalHeaders, body: jsonEncode(body));
      } else if (method == 'PATCH') {
        response = await client.patch(Uri.parse(url), headers: finalHeaders, body: jsonEncode(body));
      } else if (method == 'DELETE') {
        response = await client.delete(Uri.parse(url), headers: finalHeaders, body: jsonEncode(body));
      } else {
        throw Exception('Invalid HTTP method');
      }

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        final errorMessage = jsonResponse["error"] ?? "An error occurred";
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      rethrow;
    }
  }
}
