import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/data/models/admin_service.dart';
import 'package:yjg/auth/data/models/token_response.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class LoginDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // * 외국인 유학생 로그인
  Future<String> postStudentLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/user/login';
    final body = jsonEncode(<String, String>{
      'email': loginState.email,
      'password': loginState.password,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    debugPrint('postStudentLoginAPI 토큰 교환 결과: ${response.body}, ${response.statusCode}');
    Tokengenerated tokenGenerated =
        Tokengenerated.fromJson(json.decode(response.body));

    if (response.statusCode == 200) {
      String? token = tokenGenerated.accessToken; // 토큰값 추출
      int userId = tokenGenerated.user!.id!; // 사용자 ID 추출
      String studentName = tokenGenerated.user!.name!; // 사용자 이름 추출
      

      if (token != null) {
        await storage.write(key: 'auth_token', value: token); // 토큰 저장
        debugPrint('토큰 저장: $token');
        ref.read(userIdProvider.notifier).setUserId(userId); // 사용자 ID 저장
        ref.read(studentNameProvider.notifier).setStudentName(studentName); // 사용자 이름 저장
      } else {
        throw Exception('토큰이 없습니다.');
      }
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return utf8.decode(response.bodyBytes);
  }

// * 관리자 로그인
  Future<http.Response> postAdminLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/admin/login';
    final body = jsonEncode(<String, String>{
      'email': loginState.email,
      'password': loginState.password,
    });

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body);


    debugPrint("postAdminLoginAPI 토큰 교환 결과: ${jsonDecode(utf8.decode(response.bodyBytes))}, ${response.statusCode}");

    if (response.statusCode == 200) {
      final result = Admingenerated.fromJson(jsonDecode(response.body));
      String? token = result.token; // 토큰값 추출
      int adminId = result.admin!.id!; // 관리자 ID 추출

      if (token != null) {
        await storage.write(key: 'auth_token', value: token); // 토큰 저장
        ref.read(adminIdProvider.notifier).setAdminId(adminId); // 관리자 ID 저장

        // 관리자 권한 유형 관리
        if (result.admin != null) {
          ref
              .read(adminPrivilegesProvider.notifier)
              .updatePrivileges(result.admin!);
        }
      } else {
        throw Exception('토큰이 없습니다.');
      }
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }
}
