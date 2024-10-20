import 'package:tdlib/td_api.dart';

abstract class _EnvConfig {
  static SetTdlibParameters getTdlibParameters({required String databaseDirectory, required String filesDirectory}) {
    return SetTdlibParameters(
      apiHash: 'xxx',
      apiId: 0000,
      systemLanguageCode: 'en-US',
      deviceModel: 'device model',
      systemVersion: 'systemversion',
      applicationVersion: '0.0.1',
      useTestDc: true,
      databaseDirectory: databaseDirectory,
      filesDirectory: filesDirectory,
      databaseEncryptionKey: 'xxxxxxxx',
      useFileDatabase: true,
      useChatInfoDatabase: false,
      useMessageDatabase: false,
      useSecretChats: false,
    );
  }
}

