import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
Future<dynamic> apiHandler(
    String url,
    http.Client client,
    String method, {
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      File? file,
      bool authorization = false,
    }) async {
  method = method.toUpperCase();
  http.Response? response;

  try {
    String token = await Hive.box('SETTINGS').get('token') ?? "";

    Map<String, String> finalHeaders = {
      'Authorization': 'Bearer $token',
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

    finalHeaders['Content-Type'] = 'application/json; charset=UTF-8';

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
      throw Exception('Invalid method');
    }

    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse;
    } else {
      print(jsonResponse);
      final errorMessage = jsonResponse["message"] ?? "An error occurred";
      throw Exception(errorMessage);
    }
  } on SocketException catch (_) {
    throw const SocketException("No Internet Connection");
  } catch (e) {
    rethrow;
  }
}
