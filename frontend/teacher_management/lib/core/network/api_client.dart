import 'package:dio/dio.dart';

class ApiClient {
  static const baseUrl =
      'https://app-mobile-teacher-management.onrender.com/api';
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
      ),
    );
  }
}
