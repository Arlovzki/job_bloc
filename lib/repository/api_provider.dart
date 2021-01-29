import 'package:dio/dio.dart';
import 'package:jobs_bloc/repository/repository_constants.dart';

class ApiProvider {
  final CancelToken token = CancelToken();

  Dio dio = Dio(
    BaseOptions(
      baseUrl: DOMAIN_URL,
      connectTimeout: 25000,
      receiveTimeout: 100000,
      headers: httpOptions,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
    ),
  );

  Future makeRequest({
    String urlPath,
    dynamic jsonData,
    String method = POST_METHOD,
  }) async {
    print(jsonData);
    if (method == POST_METHOD) {
      return await this.post(urlPath, jsonData);
    } else if (method == GET_METHOD) {
      return await this.get(urlPath, jsonData);
    }
  }

  post(String url, dynamic jsonData) async {
    return await dio.post(url, data: jsonData);
  }

  get(String url, dynamic jsonData) async {
    return await dio.get(url, queryParameters: jsonData);
  }

  cancelRequest() {
    token.cancel("cancelled");
  }
}
