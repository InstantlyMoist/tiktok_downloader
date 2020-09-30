import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareSubscription {

  //static StreamSubscription _streamSubscription;

  static void init({Function onShareDataReceived}) {

    ReceiveSharingIntent.getTextStream().listen((String value) {
      onShareDataReceived(value);
      ReceiveSharingIntent.reset();
    }, onError: (err) {
      print("link go brrr: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null) return;
      onShareDataReceived(value);
      ReceiveSharingIntent.reset();
    });
  }
}
