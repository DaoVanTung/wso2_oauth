library wso2_auth;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'src/ui/auth_view_stub.dart'
    if (dart.library.html) 'src/ui/auth_view_web.dart'
    if (dart.library.io) 'src/ui/auth_view_mobile.dart';

part 'src/wso2_auth_base.dart';
