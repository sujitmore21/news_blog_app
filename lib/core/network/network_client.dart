import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

part 'network_client.g.dart';

/// Network configuration and API client
class NetworkClient {
  static late Dio _dio;
  static late RestClient _restClient;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);

    _restClient = RestClient(_dio);
  }

  static RestClient get client => _restClient;
  static Dio get dio => _dio;
}

/// Authentication interceptor
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add API key to all requests (GNews expects 'apikey' in lowercase)
    options.queryParameters['apikey'] = AppConstants.apiKey;
    super.onRequest(options, handler);
  }
}

/// Logging interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Query Parameters: ${options.queryParameters}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Message: ${err.message}');
    super.onError(err, handler);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Failure failure;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        failure = const NetworkFailure(message: 'Connection timeout');
        break;
      case DioExceptionType.badResponse:
        failure = ServerFailure(
          message: err.response?.data?['message'] ?? 'Server error',
          code: err.response?.statusCode,
        );
        break;
      case DioExceptionType.cancel:
        failure = const NetworkFailure(message: 'Request cancelled');
        break;
      case DioExceptionType.connectionError:
        failure = const NetworkFailure(message: 'No internet connection');
        break;
      default:
        failure = const UnknownFailure(message: 'Unknown error occurred');
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: failure,
        type: err.type,
      ),
    );
  }
}

/// REST client interface
@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/top-headlines')
  Future<Map<String, dynamic>> getTopHeadlines(
    @Query('category') String? category,
    @Query('country') String? country,
    @Query('lang') String? language,
    @Query('max') int max,
    @Query('page') int page,
  );

  @GET('/search')
  Future<Map<String, dynamic>> searchNews(
    @Query('q') String? query,
    @Query('lang') String? language,
    @Query('country') String? country,
    @Query('max') int max,
    @Query('page') int page,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('sortby') String? sortBy,
  );
}
