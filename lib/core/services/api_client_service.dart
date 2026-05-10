import 'package:dio/dio.dart';

abstract class ApiClientService {
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<dynamic>> post(String path, {Object? data});
  Future<Response<dynamic>> patch(String path, {Object? data});
  Future<Response<dynamic>> delete(String path, {Object? data});
}

class DioApiClientService implements ApiClientService {
  DioApiClientService({
    String? baseUrl,
    Dio? dio,
    Future<String?> Function()? idTokenProvider,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl:
                   baseUrl ??
                   const String.fromEnvironment(
                     'API_BASE_URL',
                     defaultValue: 'http://127.0.0.1:8080/v1',
                   ),
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 30),
             ),
           ),
       _idTokenProvider = idTokenProvider {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              if (_idTokenProvider != null) {
                final token = await _idTokenProvider();
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }
              handler.next(options);
            },
      ),
    );
  }

  final Dio _dio;
  final Future<String?> Function()? _idTokenProvider;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  @override
  Future<Response<dynamic>> post(String path, {Object? data}) {
    return _dio.post<dynamic>(path, data: data);
  }

  @override
  Future<Response<dynamic>> patch(String path, {Object? data}) {
    return _dio.patch<dynamic>(path, data: data);
  }

  @override
  Future<Response<dynamic>> delete(String path, {Object? data}) {
    return _dio.delete<dynamic>(path, data: data);
  }
}
