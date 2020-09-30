import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:tiktokdownloader/checkers/url_checker.dart';
import 'package:tiktokdownloader/services/download_service.dart';
import 'package:tiktokdownloader/subscriptions/share_subscription.dart';
import 'package:tiktokdownloader/widgets/arrow_widget.dart';
import 'package:tiktokdownloader/widgets/search_bar.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  final formKey = GlobalKey<FormState>();
  TextEditingController _controller;

  int _percentage = 0;

  @override
  void initState() {
    super.initState();
    ShareSubscription.init(onShareDataReceived: (value) {
      print("Received value: $value");
      if (!URLChecker.isURLValid(value)) return;
      download(value);
    });
    _controller = new TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (await Permission.storage.request().isGranted) {
      // cool, we can continue
      print('can write now');
    } else {
      print('cant write :(');
    }
  }

  void download(String downloadLink) async {
    String mediaLink = await DownloadService.getMediaUrl(downloadLink);
    DownloadService.download(mediaLink, context);
  }

  void submit() {
    if (formKey.currentState.validate()) {
      print(_controller.value.text);
      download(_controller.value.text);
      formKey.currentState.reset();
    } else {
      print("URL INCORRECT LOOOL");
    }
  }

  // TODO: Actually parse link and check if it's correct.
  // TODO: Find v19 link
  // TODO: Download tiktok on device

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8E63E8), Color(0xFF3E3E3E)],
        )),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(bottom: 45, top: 90, right: 40, left: 40),
            child: Column(
              children: <Widget>[
                ArrowWidget(),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: SearchBar(
                    controller: _controller,
                    onSubmit: () => submit(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
