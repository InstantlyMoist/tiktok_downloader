import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadPopup extends StatefulWidget {
  @override
  _DownloadPopupState createState() => _DownloadPopupState();

  final Stream stream;

  DownloadPopup(this.stream);
}

class _DownloadPopupState extends State<DownloadPopup> {

  int _percentage = 0;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((value) {
      setState(() {
        _percentage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("$_percentage"),
    );
  }
}
