import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdlib/td_api.dart' as td;
import 'package:tdlib/td_client.dart';

import 'env_config.dart';

void main() async {
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
  /*// Creating an instance of the Options class
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
  );*/
  final TextEditingController _textController = TextEditingController();

  late Client client;

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
              'constClientId.toString()',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () async {
                client = Client.create();

                client.updates.listen((td.TdObject event) async {
                  print('update: ${event.toJson()}');
                });
                await client.initialize();

                td.Ok result = client.execute<td.Ok>(const td.SetLogVerbosityLevel(newVerbosityLevel: 0));
                print('execute result: ${result.toJson()}');

                td.Updates sendResult = await client.send<td.Updates>(const td.GetCurrentState());
                print('send result: ${sendResult.toJson()}');
                //TdPlugin.initialize(options);
              },
              child: const Text('refreshClientId'),
            ),
            TextButton(
              onPressed: () async {
                final appDocDir = await getApplicationDocumentsDirectory();
                final td.SetTdlibParameters params = EnvConfig.getTdlibParameters(
                  databaseDirectory: appDocDir.path,
                  filesDirectory: appDocDir.path,
                );
                final sendResult = await client.send(params);
                print('send result: ${sendResult.toJson()}');
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
                  onPressed: () async {
                    final sendResult = await client.send(
                      td.SetAuthenticationPhoneNumber(
                        phoneNumber: _textController.text,
                        settings: const td.PhoneNumberAuthenticationSettings(
                          allowFlashCall: false,
                          isCurrentPhoneNumber: false,
                          allowSmsRetrieverApi: false,
                          allowMissedCall: false,
                          authenticationTokens: [],
                          hasUnknownPhoneNumber: false,
                        ),
                      ),
                    );
                    print('send result: ${sendResult.toJson()}');
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
                  onPressed: () async {
                    final sendResult = await client.send(
                      td.CheckAuthenticationCode(
                        code: _textController.text,
                      ),
                    );
                    print('send result: ${sendResult.toJson()}');
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
                    /*TdPlugin.instance.tdSend(
                      constClientId,
                      td.CheckAuthenticationPassword(
                        password: _textController.text,
                      ),
                    );*/
                  },
                  child: const Text('enter password'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                /*TdPlugin.instance.tdSend(
                  constClientId,
                  const td.GetChats(limit: 30),
                );*/
              },
              child: const Text('GetChats'),
            ),
          ],
        ),
      ),
    );
  }
}
