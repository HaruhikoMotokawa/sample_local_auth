/// 生体認証の状態を表す列挙型
enum LocalAuthStatus {
  /// デバイスが生体認証に対応しており、問題なく利用可能
  available('デバイスが生体認証に対応しており、問題なく利用可能です。'),

  /// ユーザーが生体認証を登録していない
  biometricNotEnrolled(
    '生体認証が登録されていません。設定アプリで指紋や顔認証を登録してください。',
  ),

  /// デバイスが生体認証やPIN、パスコードなどの認証手段を一切サポートしていない
  noAuthenticationMethodAvailable(
    '生体認証やPIN、パスコードなどの登録がされていません。設定アプリで登録してください。',
  ),

  /// 生体認証が利用可能なデバイスではない
  biometricNotSupported(
    'このデバイスでは生体認証はサポートされていません。',
  );

  const LocalAuthStatus(this.message);

  /// 各ステータスに対応する説明メッセージ
  final String message;
}
