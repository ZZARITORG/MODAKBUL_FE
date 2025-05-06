import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:modakbul/services/auth_service.dart';

///TODO: 열거형으로 상태관리 생각해보기
class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  FirebaseAuthService._internal();

  factory FirebaseAuthService() => _instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';
  bool isExpired = false;
  PhoneAuthCredential? credential;

  ///전화번호로 인증번호(OTP)를 보내는 함수
  Future<void> sendVerificationCode(
      String phoneNumber,
      Function onSignInSuccess,
      Function(String) onSignInFailure,
      {
        Function(PhoneAuthCredential)? onEditVerified,
      }
      ) async {

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+82$phoneNumber',
        timeout: const Duration(seconds: 30),

        ///인증번호 보내기 성공
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (onEditVerified != null) {
            print('번호변경');
            onEditVerified(credential);
          } else {
            print('로그인');
            await firebaseAuth.signInWithCredential(credential).then((_) {
              onSignInSuccess();
            });
          }
        },

        ///인증번호 보내기 실패
        verificationFailed: (FirebaseAuthException e) {
          onSignInFailure(e.code);
        },

        /// OTP 전송 후 처리
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },

        /// 자동으로 인증이 끝났을 때의 처리
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          isExpired = true;
        },
      );
    } catch (e) {
      onSignInFailure('알 수 없는 오류가 발생했습니다.');
    }
  }

  ///인증번호를 검증하는 함수
  Future<void> verifyVerificationCode(
      String smsCode,
      Function onSignInSuccess,
      Function(String) onSignInFailure,
      {
        Function(PhoneAuthCredential)? onEditVerified,
      }
      ) async {

    /*if (isExpired) {
      onSignInFailure('expired-action-code');
      return;
    }*/

    credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    if (onEditVerified != null) {
      print('번호변경');
      onEditVerified(credential!);
    } else {
      try {
      await firebaseAuth.signInWithCredential(credential!).then((_) {
        onSignInSuccess();
      });
    } on FirebaseAuthException catch (e) {
      onSignInFailure(e.code);
    }
    }
  }

  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {
    try {

      final user = FirebaseAuth.instance.currentUser;

      await user?.updatePhoneNumber(credential);
    } catch (e) {
      throw Exception('Phone number update failed: $e');
    }
  }

  String getVerificationId() {
    return _verificationId;
  }

}
