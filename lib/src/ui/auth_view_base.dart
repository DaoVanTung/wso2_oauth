import 'package:flutter/material.dart';

abstract class AuthViewBase extends StatefulWidget {
  const AuthViewBase({
    Key? key,
    required this.initialUri,
    this.onCodeReceived,
    this.onPageFinished,
  }) : super(key: key);
  final Uri initialUri;
  final Function(String)? onCodeReceived;
  final Function(String)? onPageFinished;
}
