import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:sample_local_auth/core/log/logger.dart';
import 'package:sample_local_auth/data/sources/local_auth.dart';

abstract interface class LocalAuthRepositoryBase {
  /// 生体認証が利用可能かどうかを取得する
  Future<bool> get isAvailable;

  /// 生体認証の設定を行なっているかどうかを取得する
  Future<List<BiometricType>> get isSetting;

  /// 生体認証を行う
  Future<bool> authenticate();
}

class LocalAuthRepository implements LocalAuthRepositoryBase {
  LocalAuthRepository(this.ref);

  final ProviderRef<dynamic> ref;

  LocalAuthentication get _localAuth => ref.read(localAuthenticationProvider);

  @override
  Future<bool> get isAvailable => _localAuth.canCheckBiometrics;

  @override
  Future<List<BiometricType>> get isSetting =>
      _localAuth.getAvailableBiometrics();

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'アプリのロックを解除するために生体認証を行います',
      );
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notAvailable:
          logger.e(
            'デバイスが生体認証に対応していません',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.passcodeNotSet:
          logger.e(
            'デバイスにパスコード/PINが設定されていません',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.notEnrolled:
          logger.e(
            'デバイスに生体認証が登録されていません',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.otherOperatingSystem:
          logger.e(
            'このOSでは生体認証はサポートされていません',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.lockedOut:
          logger.e(
            '生体認証が一時的にロックされています。しばらくお待ちください。',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.permanentlyLockedOut:
          logger.e(
            '生体認証がロックされました。PIN/パスコードでの解除が必要です。',
            error: e,
            stackTrace: StackTrace.current,
          );
        case auth_error.biometricOnlyNotSupported:
          logger.e(
            'Windowsでは生体認証のみの使用はサポートされていません',
            error: e,
            stackTrace: StackTrace.current,
          );
        default:
          logger.e(
            '原因不明のエラーで生体認証に失敗しました',
            error: e,
            stackTrace: StackTrace.current,
          );
      }
      return false;
    }
  }
}
