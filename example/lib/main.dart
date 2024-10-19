import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tdlib/td_api.dart' as td;
import 'package:tdlib/tdlib.dart';
import 'package:tdlib_example/telegram_service.dart';

final GetIt locator = GetIt.instance;

TelegramService telegramService() => locator.get();

const constClientId = 1;

void setupLocator() {
  locator.registerSingleton(TelegramService());
}

void main() async {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Creating an instance of the Options class
  final options = TdInitOptions(
    onUpdate: (update) {
      log("Update received: $update");
      //final event = jsutil.dartify(update);
      //print("Update received: $event");
    },
    instanceName: "MyTdClientInstance",
    // Custom instance name
    isBackground: false,
    // Not running in the background
    jsLogVerbosityLevel: 'debug',
    // JavaScript log level
    logVerbosityLevel: 3,
    // TDLib log level
    useDatabase: false,
    // Use database
    readOnly: false,
    // Not in read-only mode
    mode: 'wasm', // Use auto mode for TDLib build 'asmjs', 'wasm', 'auto',
  );
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test TDLib Plugin, Client ID:',
            ),
            Text(
              constClientId.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {
                TdPlugin.initialize(options);
              },
              child: const Text('refreshClientId'),
            ),
            TextButton(
              onPressed: () {
                TdPlugin.instance.tdSend(
                  constClientId,
                  const td.SetTdlibParameters(
                    useTestDc: false,
                    useSecretChats: false,
                    useMessageDatabase: false,
                    useFileDatabase: false,
                    useChatInfoDatabase: false,
                    ignoreFileNames: false,
                    enableStorageOptimizer: false,
                    systemLanguageCode: 'EN',
                    filesDirectory: '/',
                    databaseDirectory: '/db',
                    applicationVersion: '0.0.1',
                    deviceModel: 'Unknown',
                    systemVersion: 'Unknonw',
                    apiId: 29589693,
                    apiHash: 'dc484c30ac640e8229e94fbe986e1c0e',
                    databaseEncryptionKey: 'YXNkYXNk',
                  ),
                );
              },
              child: const Text('setTdlibParameters'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                      labelText: "number",
                      //contentPadding: EdgeInsets.zero
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    TdPlugin.instance.tdSend(
                      constClientId,
                      td.SetAuthenticationPhoneNumber(
                        phoneNumber: _textController.text,
                        settings: const td.PhoneNumberAuthenticationSettings(
                          allowFlashCall: false,
                          isCurrentPhoneNumber: false,
                          allowSmsRetrieverApi: false,
                          allowMissedCall: false,
                          authenticationTokens: [],
                        ),
                      ),
                    );
                  },
                  child: const Text('login with number'),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    maxLength: 5,
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "code",
                      errorStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                      //contentPadding: EdgeInsets.zero
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    TdPlugin.instance.tdSend(
                      constClientId,
                      td.CheckAuthenticationCode(
                        code: _textController.text,
                      ),
                    );
                  },
                  child: const Text('enter code'),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "pass",
                      errorStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                      //contentPadding: EdgeInsets.zero
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    TdPlugin.instance.tdSend(
                      constClientId,
                      td.CheckAuthenticationPassword(
                        password: _textController.text,
                      ),
                    );
                  },
                  child: const Text('enter password'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                TdPlugin.instance.tdSend(
                  constClientId,
                  const td.GetChats(limit: 30),
                );
              },
              child: const Text('GetChats'),
            ),
          ],
        ),
      ),
    );
  }
}
