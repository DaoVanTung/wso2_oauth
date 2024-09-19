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
  Widget build(BuildContext context) {
    throw UnimplementedError('This platform is not supported');
  }
}
