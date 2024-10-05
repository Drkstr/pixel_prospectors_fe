import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioService {
  final Dio _dio;

  DioService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        );

  Dio get dio => _dio;
}

final dioServiceProvider = Provider.autoDispose<DioService>((ref) => DioService());
