import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;


Future<dynamic> apiHandler(
    String url,
    http.Client client,
    String method, {
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool authorization = false,
    }) async {
  method = method.toUpperCase();
  http.Response response;

  String token = await Hive.box('SETTINGS').get('token') ?? "";

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token',
  };

  if (method.toUpperCase() == 'GET') {
    response = await client.get(
      Uri.parse(url),
      headers: headers,
    );
  } else if (method.toUpperCase() == 'POST') {
    response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  } else if (method.toUpperCase() == 'PUT') {
    response = await client.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  } else if (method.toUpperCase() == 'PATCH') {
    response = await client.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  } else if (method.toUpperCase() == 'DELETE') {
    response = await client.delete(Uri.parse(url), headers: headers, body: body);
  } else {
    throw Exception('Invalid method');
  }

  var jsonResponse = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonResponse;
  } else {
    final errorMessage =jsonResponse["error"]?? "An error occurred";

    throw Exception(errorMessage);
  }
}
