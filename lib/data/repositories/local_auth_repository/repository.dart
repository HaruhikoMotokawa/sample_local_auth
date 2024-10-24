import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ここをインポートすると、local_authのエラーコードが使えるようになる
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:sample_local_auth/core/log/logger.dart';
import 'package:sample_local_auth/data/sources/local_auth.dart';
import 'package:sample_local_auth/domains/local_auth_status.dart';

abstract interface class LocalAuthRepositoryBase {
  /// 生体認証に対応しているデバイスかどうか
  Future<bool> get isAvailable;

  /// 生体認証が使用可能かを返す
  Future<LocalAuthStatus> get status;

  /// 生体認証を行う
  Future<bool> authenticate();
}

class LocalAuthRepository implements LocalAuthRepositoryBase {
  LocalAuthRepository(this.ref);

  final Ref ref;

  LocalAuthentication get _localAuth => ref.read(localAuthenticationProvider);

  @override
  Future<bool> get isAvailable => _localAuth.canCheckBiometrics;

  @override
  Future<LocalAuthStatus> get status async {
    // 何かの認証が登録されているか（主にpinコードか、パスコードが登録されるとtrueになる）
    // PINコードまたはパスコードが登録されていない状態で生体認証が登録されることはない
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    // 登録されている生体認証のリスト
    final availableBiometrics = await _localAuth.getAvailableBiometrics();
    // 登録されている生体認証があるかどうか？
    final hasBiometrics = availableBiometrics.isNotEmpty;

    logger.d(
      ' 登録されてるか:$availableBiometrics,'
      ' 認証系の登録を何かしているか？: $isDeviceSupported',
    );
    switch ((isDeviceSupported, hasBiometrics)) {
      case (true, true):
        return LocalAuthStatus.available;
      case (true, false):
        return LocalAuthStatus.biometricNotEnrolled;
      case (false, _):
        return LocalAuthStatus.noAuthenticationMethodAvailable;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'アプリのロックを解除するために生体認証を行います',
        // プラットフォームごとのメッセージをカスタマイズする
        authMessages: [
          // 生体認証を再設定するようにユーザーに促すメッセージ
          // ここを設定しておかないと認証の登録がされていない場合に英語のメッセージでたりする？
          // 言語設定してれば大丈夫かも？
          const IOSAuthMessages(
            lockOut: '生体認証が無効になっています。再設定してください',

            // 設定ページに移動するボタンのテキスト（最大30文字）
            goToSettingsButton: '設定へ',

            // 生体認証を設定するように促す説明
            goToSettingsDescription: '設定で生体認証を有効にしてください',

            // ダイアログを閉じるボタンのテキスト（最大30文字）
            cancelButton: 'キャンセル',

            // 認証ダイアログ内で表示されるフォールバックボタンのローカライズされたタイトル
            localizedFallbackTitle: '別の方法で認証する',
          ),
          // 生体認証のヒントメッセージ（最大60文字）
          const AndroidAuthMessages(
            biometricHint: '指紋センサーに触れてください',

            // 認証が失敗した時のメッセージ（最大60文字）
            biometricNotRecognized: '認証に失敗しました。再試行してください',

            // 生体認証が設定されていないときに表示されるタイトル（最大60文字）
            biometricRequiredTitle: '生体認証が設定されていません',

            // 認証成功時のメッセージ（最大60文字）
            biometricSuccess: '認証が成功しました',

            // ダイアログを閉じるボタンのテキスト（最大30文字）
            cancelButton: 'キャンセル',

            // デバイス認証が設定されていないときのタイトル（最大60文字）
            deviceCredentialsRequiredTitle: 'デバイス認証が設定されていません',

            // デバイス認証の設定を促す説明
            deviceCredentialsSetupDescription: '設定でデバイス認証を有効にしてください',

            // 設定ページに移動するボタンのテキスト（最大30文字）
            goToSettingsButton: '設定へ',

            // 生体認証の設定を促す説明
            goToSettingsDescription: '設定で生体認証を有効にしてください',

            // 生体認証が必要な操作のダイアログタイトル（最大60文字）
            signInTitle: '生体認証を使用してサインインしてください',
          ),
        ],
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
}
