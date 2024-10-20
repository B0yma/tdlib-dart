import 'dart:developer';

import 'package:flutter/foundation.dart';
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
            TextButton(
              onPressed: () async {
                client = Client.create();

                client.updates.listen((td.TdObject event) async {
                  log('update: ${event.toJson()}');
                });
                await client.initialize(
                  tdWebInitOptions: EnvConfig.tdWebInitOptions,
                );
              },
              child: const Text('initialize'),
            ),
            TextButton(
              onPressed: () async {
                late td.SetTdlibParameters params;
                if (kIsWeb) {
                  params = EnvConfig.tdlibParameters(
                    databaseDirectory: '/db',
                    filesDirectory: '/',
                  );
                } else {
                  final appDocDir = await getApplicationDocumentsDirectory();
                  params = EnvConfig.tdlibParameters(
                    databaseDirectory: appDocDir.path,
                    filesDirectory: appDocDir.path,
                  );
                }
                await client.send(params);
              },
              child: const Text('setTdlibParameters'),
            ),
            InputWidget(
              label: 'number',
              onClick: () async {
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
                log('send result: ${sendResult.toJson()}');
              },
              buttonText: 'login with number',
            ),
            InputWidget(
              label: 'enter code',
              onClick: () async {
                final sendResult = await client.send(
                  td.CheckAuthenticationCode(
                    code: _textController.text,
                  ),
                );
                log('send result: ${sendResult.toJson()}');
              },
              buttonText: 'enter code',
            ),
            InputWidget(
              label: 'enter password',
              onClick: () async {
                final sendResult = await client.send(
                  td.CheckAuthenticationPassword(
                    password: _textController.text,
                  ),
                );
                log('send result: ${sendResult.toJson()}');
              },
              buttonText: 'enter password',
            ),
            TextButton(
              onPressed: () async {
                final sendResult = await client.send(
                  const td.GetChats(limit: 30),
                );
                log('send result: ${sendResult.toJson()}');
              },
              child: const Text('GetChats'),
            ),
          ],
        ),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  InputWidget({
    super.key,
    required this.label,
    required this.onClick,
    required this.buttonText,
  });

  final String label;
  final String buttonText;
  final VoidCallback onClick;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: 200,
          child: TextField(
            controller: _textController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(),
              ),
              labelText: label,
              errorStyle: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            onClick();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
