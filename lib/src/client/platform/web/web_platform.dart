import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';

import 'package:rxdart/rxdart.dart';
import 'package:tdlib/src/client/td_web_init_options.dart';

import '../../../../td_api.dart';
import '../platform.dart';

class PlatformImpl implements Platform {
  static late final TdWebPlatform _platform;
  final PublishSubject<Event> _eventsSubject = PublishSubject<Event>();

  @override
  void destroy() {
    _eventsSubject.close();
  }

  @override
  Stream<Event> get events => _eventsSubject;

  @override
  Map<String, dynamic> execute({required Map<String, dynamic> function}) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  Future<void> initialize({TdWebInitOptions? tdWebInitOptions}) async {
    log('initialize from web');
    final optionsWithCallback = TdWebInitOptionsWithCallback(
      onUpdate: (update) {
        log("Update received: $update");
        final Map<String, dynamic> newJson = jsonDecode(update);
        TdObject? object = newJson.toTdObject();
        if (object != null) {
          int? extra = newJson['@extra'];
          _eventsSubject.add(
            Event(
              object: object,
              extra: extra,
            ),
          );
        } else {
          log('TdObject == null');
        }
      },
      tdWebInitOptions: tdWebInitOptions!,
    );
    _platform = TdWebPlatform(optionsWithCallback.toExternalReference);
  }

  @override
  Future<void> send({required Map<String, dynamic> function}) async {
    _platform.send(function.jsify());
  }
}

@JS("tdweb.default")
extension type TdWebPlatform._(JSObject o) implements JSObject {
  external factory TdWebPlatform(ExternalDartReference options);
  external void send(JSAny? event);
}

