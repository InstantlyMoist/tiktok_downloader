import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokdownloader/checkers/url_checker.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();

  final TextEditingController controller;
  final VoidCallback onSubmit;

  SearchBar({this.controller, this.onSubmit});

}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver{

  final FocusNode inputFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) inputFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onFieldSubmitted: (value) => widget.onSubmit(),
      validator: (value) {
        if (!URLChecker.isURLValid(value)) return "";
        return null;
      },
      focusNode: inputFocusNode,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.link,
          color: Colors.black,
        ),
        hintText: "Enter URL to download",
        hintStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 14.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8E63E8), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8E63E8), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        errorStyle: TextStyle(
          fontSize: 0
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8E63E8), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8E63E8), width: 2),
          borderRadius: BorderRadius.circular(5),
        )
      ),
    );
  }
}
