// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
    window.open(widget.initialUri.toString(), '_self');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Container(),
    );
  }
}
