import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String? linkUrl;
  final String title;
  final VoidCallback? onLeadingPressed; // New callback function

  const WebViewScreen({
    Key? key,
    this.linkUrl,
    required this.title,
    this.onLeadingPressed, // Updated parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WebView(
        initialUrl: linkUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}