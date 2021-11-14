import 'package:flutter/material.dart';

abstract class BaseScreen extends StatelessWidget {
  // AppBar
  Widget appBar(BuildContext context) => null;
  // Page Content
  Widget body(BuildContext context) => Container();

  bool resizeToAvoidBottomInset() => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
      body: SafeArea(
        child: body(context),
      ),
    );
  }
}
