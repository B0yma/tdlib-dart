class TdWebInitOptions {
  final String instanceName;
  final bool isBackground;
  final String jsLogVerbosityLevel;
  final int logVerbosityLevel;
  final bool useDatabase;
  final bool readOnly;
  final String mode;

  TdWebInitOptions({
    required this.instanceName,
    required this.isBackground,
    required this.jsLogVerbosityLevel,
    required this.logVerbosityLevel,
    required this.useDatabase,
    required this.readOnly,
    required this.mode,
  });
}

class TdWebInitOptionsWithCallback {
  final Function(String) onUpdate;
  final TdWebInitOptions tdWebInitOptions;

  TdWebInitOptionsWithCallback({
    required this.onUpdate,
    required this.tdWebInitOptions,
  });
}