import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart';

abstract class EntityHttpService {
  final String baseUrl;
  final String controllerName;
  final int defaultTimeoutSec;
  final Client _httpClient;

  EntityHttpService(
      {required this.baseUrl,
      required this.controllerName,
      this.defaultTimeoutSec = 30})
      : _httpClient = Client();

  // Post request
  Future<void> postAsync(
      {required PostMealRequestBody requestBody, int? timeoutSec}) async {
    Uint8List? requestContent;
    final jsonString = JsonSerialize.serialize(requestBody);
    requestContent = utf8.encode(jsonString);

    final Response response = await _httpClient
        .post(
          Uri.parse('$baseUrl/$controllerName'),
          headers: {'Content-Type': 'application/json'},
          body: requestContent,
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
  }

  // Get search request
  Future<T> getSearchAsync<T>(
      {required String filter,
      required String searchWord,
      int? timeoutSec}) async {
    final Response response = await _httpClient
        .get(
          Uri.parse('$baseUrl/$controllerName/search/$filter/$searchWord'),
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
    return JsonSerialize.deserialize<T>(response.body);
  }

  // Get request by ID
  Future<T> getAsync<T>({required String id, int? timeoutSec}) async {
    final Response response = await _httpClient
        .get(
          Uri.parse('$baseUrl/$controllerName/$id'),
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
    return JsonSerialize.deserialize<T>(response.body);
  }

  // Get all request
  Future<T> getAllAsync<T>({int? timeoutSec}) async {
    final Response response = await _httpClient
        .get(
          Uri.parse('$baseUrl/$controllerName'),
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
    return JsonSerialize.deserialize<T>(response.body);
  }

  // Put request
  Future<T> putAsync<T>(
      {required int id,
      required PutMealRequestBody requestBody,
      int? timeoutSec}) async {
    Uint8List? requestContent;
    final jsonString = JsonSerialize.serialize(requestBody);
    requestContent = utf8.encode(jsonString);

    final Response response = await _httpClient
        .put(
          Uri.parse('$baseUrl/$controllerName/$id'),
          headers: {'Content-Type': 'application/json'},
          body: requestContent,
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
    return JsonSerialize.deserialize<T>(response.body);
  }

  // Delete request
  Future<void> deleteAsync({required int id, int? timeoutSec}) async {
    final Response response = await _httpClient
        .delete(
          Uri.parse('$baseUrl/$controllerName/$id'),
        )
        .timeout(Duration(seconds: timeoutSec ?? defaultTimeoutSec));

    ensureSuccessfulStatusCode(response);
  }

  void ensureSuccessfulStatusCode(Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      //throw HttpException('Request failed with status: ${response.statusCode}');
    }
  }
}

class MealHttpService extends EntityHttpService {
  static MealHttpService instance = MealHttpService._internal(
      baseUrl: "https://localhost:5000/api", controllerName: "ManageMeals");

  MealHttpService._internal(
      {required super.baseUrl, required super.controllerName});

  factory MealHttpService() {
    return instance;
  }
}

class HttpPostRequestBody {}

class HttpPutRequestBody {
  final int id;

  HttpPutRequestBody({required this.id});
}

//Expenses request
class PostMealRequestBody extends HttpPostRequestBody {
  final String title;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  PostMealRequestBody({
    required this.title,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
    };
  }
}

class PutMealRequestBody extends HttpPutRequestBody {
  final String title;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  PutMealRequestBody({
    required super.id,
    required this.title,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'title': title,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
    };
  }
}

abstract class JsonSerialize {
  // Deserialize JSON to object
  static T deserialize<T>(String responseBody) {
    try {
      return jsonDecode(responseBody) as T;
    } catch (e) {
      throw FormatException(
          'JSON: Error deserializing the response body to ${T.runtimeType.toString()}. Exception body: $e');
    }
  }

  // Deserialize JSON to object
  static String serialize<T>(T object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      throw FormatException(
          'JSON: Error serializing the ${T.runtimeType.toString()} object. Exception body: $e');
    }
  }
}
