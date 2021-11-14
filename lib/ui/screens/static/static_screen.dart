import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopizy/services/global_services/static_page_service.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticScreen extends StatefulWidget {
  final String title;
  final String pageName;

  StaticScreen({this.title, this.pageName});

  @override
  _StaticScreenState createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {
  bool loading = true;
  WebViewController _controller;
  String pageContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
              ),
            ),
          ),
          WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              Get.find<StaticPageService>().fetchPageContent(widget.pageName).then((value) {
                setState(() {
                  loading = false;
                  _controller
                      .loadUrl(Uri.dataFromString(value, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
