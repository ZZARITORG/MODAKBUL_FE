import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///TODO: 열거형으로 상태관리 생각해보기
class FirebaseAuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';
  bool isExpired = false;

  ///전화번호로 인증번호(OTP)를 보내는 함수
  Future<void> sendVerificationCode(
      String phoneNumber,
      Function onSignInSuccess,
      Function(String) onSignInFailure,
      ) async {

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+82$phoneNumber',
        timeout: const Duration(seconds: 30),

        ///인증번호 보내기 성공
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential).then((_) {
            onSignInSuccess();
          });
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
      ) async {

    /*if (isExpired) {
      onSignInFailure('expired-action-code');
      return;
    }*/

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);

    try {
      await firebaseAuth.signInWithCredential(credential).then((_) {
        onSignInSuccess();
      });
    } on FirebaseAuthException catch (e) {
      onSignInFailure(e.code);
    }
  }

  Future<void> updatePhoneNumber(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      //폰 번호 업데이트
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
    } catch (e) {
      throw Exception('Phone number update failed');
    }
  }
}
