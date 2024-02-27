import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class GoogleLoginDataSource {
  // 상수 파일에서 가져온 apiURL 사용
  String getApiUrl() {
    return apiURL;
  }

  // 구글 로그인
  static final _googleSignin = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  // 구글 로그인 통신
  Future<void> signInWithGoogle(WidgetRef ref) async {
    try {
      await _googleSignin.signIn();
      final GoogleSignInAccount? account = _googleSignin.currentUser;

      if (account != null) {
        GoogleSignInAuthentication googleAuth = await account.authentication;

        // Riverpod를 통해 User 상태를 업데이트
        ref.read(userProvider.notifier).updateWithGoogleSignIn(
              email: account.email,
              displayName: account.displayName,
            );

        debugPrint("Google User Token: ${googleAuth.accessToken}");
        debugPrint('구글 계정 정보: $account');

        // 성공 시 postGoogleLoginAPI 호출
        await postGoogleLoginAPI(ref);
      }
    } catch (error) {
      debugPrint('Error signing in with Google: $error');
    }
  }

  // 토큰 담는 곳
  static final storage = FlutterSecureStorage();

  // 구글 로그인 후 토큰 교환 통신
  Future<http.Response> postGoogleLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final body = jsonEncode(<String, String>{
      'email': loginState.email,
      'displayName': loginState.displayName,
    });

    debugPrint(body);
    final response = await http.post(Uri.parse('$apiURL/api/user/google-login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body);

    debugPrint(
        "postGoogleLoginAPI 토큰 교환 결과: ${response.body}, ${response.statusCode}");

    if (response.statusCode == 200) {
      // final jsonDate = json.decode(response.body);
      // Tokengenerated result = Tokengenerated.fromJson(jsonDate);
      // int? id = result.data?.user?.id;

      // if (id != null) {
      //   // id 값을 StateNotifier를 통해 업데이트
      //   ref.read(userIdProvider.notifier).setUserId(id);
      // }
      // String? token = result.data?.token;

      // if (token != null) {
      //   await storage.write(key: 'auth_token', value: token);
      // } else {
      //   // throw Exception('토큰이 없습니다.');
      //   debugPrint('토큰이 없습니다.');
      // }
      return response;
      // return result;
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

  // 구글 로그아웃
  static Future<void> logout() => _googleSignin.signOut();
}