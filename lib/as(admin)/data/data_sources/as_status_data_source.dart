import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class StatusDataSource {
  static final Dio dio = Dio();

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  StatusDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 상태 변경
  Future<Response> patchStatusAPI(int serviceId) async {
    String url = '$apiURL/api/after-service/status/${serviceId.toString()}';

    try {
      final response = await dio.patch(url);
      return response;
    } on DioException catch (e) {
      throw Exception('추가 정보 입력에 실패했습니다. : $e');
    }
    
    catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('상태 변경에 실패했습니다.');
    }
  }
}
