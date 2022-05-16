import 'dart:developer';

import 'package:example/tools/local_server_webview_manager.dart';
import 'package:flutter/material.dart';
import 'package:local_server_for_webview/local_server_for_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<WebPage> createState() => _WebPageState();

}

class _WebPageState extends State<WebPage> {

  // Local server 管理
  late LocalServerCacheBinder _localServerBuilder;
  WebViewController? webViewController;
  String _innerUrl = '';
  String _title = '';

  @override
  void initState() {
    super.initState();
    log('页面开始加载：${DateTime.now()}', name: 'web-time');
    _localServerBuilder = LocalServerCacheBinder()..initBinder();
    LocalServerWebViewManager.instance.registerBuilder(_localServerBuilder);
    _innerUrl = _localServerBuilder.convertH5Url2LocalServerUrl(widget.url);
  }

  @override
  void dispose() {
    LocalServerWebViewManager.instance.resignBuilder(_localServerBuilder);
    _localServerBuilder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
        ),
      ),
      body: WebView(
        initialUrl: _innerUrl,
        debuggingEnabled: true,
        onPageStarted: (url) {
          print("onPageStarted($url) ----------------------");
          log('Web开始加载：${DateTime.now()}', name: 'web-time');
        },
        onPageFinished: (url) {
          print("onPageFinished($url) ----------------------");
          log('Web加载完成：${DateTime.now()}', name: 'web-time');
        },
        onWebViewCreated: (controller) async {
          webViewController = controller;
          webViewController!.getTitle().then((value) {
            setState(() {
              _title = value ?? '';
            });
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
