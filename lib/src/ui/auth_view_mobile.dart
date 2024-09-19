import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'auth_view_base.dart';

class AuthView extends AuthViewBase {
  const AuthView({
    super.key,
    required super.initialUri,
    super.onCodeReceived,
    super.onPageFinished,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: widget.onPageFinished,
          onWebResourceError: (error) {},
          onNavigationRequest: widget.onCodeReceived != null
              ? (request) {
                  if (request.url.startsWith(
                    widget.initialUri.queryParameters['redirect_uri']!,
                  )) {
                    final uri = Uri.parse(request.url);
                    final code = uri.queryParameters['code'];
                    if (code != null && widget.onCodeReceived != null) {
                      widget.onCodeReceived!(code);
                    }
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                }
              : null,
        ),
      )
      ..loadRequest(widget.initialUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
