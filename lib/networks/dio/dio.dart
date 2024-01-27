import 'package:dio/dio.dart';

import '../endpoints.dart';
import 'log.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  void create() {
    BaseOptions options = BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 100000),
        headers: {
          NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
          NetworkConstants.X_GITHUB_API_VERSION: NetworkConstants.API_VERSION,
        });
    dio = Dio(options)..interceptors.add(Logger());
  }
}

Future<Response> postHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .post(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> putHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .put(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

Future<Response> deleteHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio
        .delete(path, data: data, cancelToken: DioSingleton.cancelToken);
