// core/network/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  static const baseUrl = 'http://10.0.2.2:8080/api'; // émulateur Android
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 8)),
    );
  }
}
