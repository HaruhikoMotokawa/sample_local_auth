import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:sample_local_auth/core/log/logger.dart';
import 'package:sample_local_auth/data/sources/local_auth.dart';
import 'package:sample_local_auth/domains/local_auth_status.dart';

abstract interface class LocalAuthRepositoryBase {
  //FIXME: statusで賄うことができるので、このゲッターは不要かもしれない
  /// 生体認証が利用可能かどうかを取得する
  Future<bool> get isAvailable;

  /// 生体認証を行う
  Future<bool> authenticate();

  /// 生体認証が使用可能かを返す
  Future<LocalAuthStatus> get status;
}

class LocalAuthRepository implements LocalAuthRepositoryBase {
  LocalAuthRepository(this.ref);

  final Ref ref;

  LocalAuthentication get _localAuth => ref.read(localAuthenticationProvider);

  @override
  Future<bool> get isAvailable => _localAuth.canCheckBiometrics;

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'アプリのロックを解除するために生体認証を行います',
      );
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notAvailable:
          if (e.message!.contains('Authentication canceled.') == true) {
            logger.i(
              'ユーザーが生体認証をキャンセルしました',
              error: e,
              stackTrace: StackTrace.current,
            );
          } else {
            logger.e(
              'デバイスが生体認証に対応していない、または生体認証の登録がされていません。',
              error: e,
              stackTrace: StackTrace.current,
            );
          }
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

  @override
  Future<LocalAuthStatus> get status async {
    // FIXME: ここの分岐はまだ未完成
    // 生体認証が利用可能なデバイスか
    final isAvailable = await _localAuth.canCheckBiometrics;
    // 何かの認証が登録されているか（主にpinコードか、パスコードが登録されるとtrueになる）
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    // 登録されている生体認証のリスト
    final availableBiometrics = await _localAuth.getAvailableBiometrics();

    logger.d(
      ' 生体認証が対応可能なデバイスか: $isAvailable,'
      ' 登録されてるか:$availableBiometrics,'
      ' デバイスが対応しているか: $isDeviceSupported',
    );
    if (availableBiometrics.isEmpty) {
      return LocalAuthStatus.biometricNotEnrolled;
    }
    // FIXME: ここは間違い、これは生体認証に対応していないデバイスの場合である
    if (isAvailable == false) {
      return LocalAuthStatus.noAuthenticationMethodAvailable;
    }

    return LocalAuthStatus.available;
  }
}
