// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:wso2_auth/wso2_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wso2Auth = Wso2Auth(
      scheme: 'https',
      host: 'sso.mkdc.com.vn',
      clientId: 'w88sitlIQmkis9PjDB3N95a5CG8a',
      clientSecret: 'HiVKWV0UIEbfQqNqPjfjvZOSVu4a',
      authEndpointPath: 'oauth2/authorize',
      tokenEndpointPath: 'oauth2/token',
      logoutEndointPath: 'oidc/logout',
      redirectUri: kDebugMode
          ? 'http://localhost:5000/callback.html'
          : 'https://files.mkdc.com.vn/callback',
      scopes: 'openid profile offline_access',
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name?.contains("callback") ?? false) {
          String code = Uri.base
              .toString()
              .substring(Uri.base.toString().indexOf('code=') + 5);

          wso2Auth.obtainAccessToken(code).then(
                (value) => Navigator.of(context).pop(value),
              );
        }
        return MaterialPageRoute(builder: (context) {
          return MyHomePage(
            title: 'Flutter Demo Home Page',
            wso2Auth: wso2Auth,
          );
        });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.wso2Auth,
  }) : super(key: key);

  final String title;
  final Wso2Auth wso2Auth;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _token;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await widget.wso2Auth.getAccessToken();
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
        _token = token;
      });
    }
  }

  Future<void> _handleLogin() async {
    await widget.wso2Auth.login(context);
    await _checkLoginStatus();
  }

  Future<void> _handleLogout() async {
    final result = await widget.wso2Auth.logout(context);
    if (result) {
      setState(() {
        _isLoggedIn = false;
        _token = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoggedIn) ...[
              Text('Token: $_token'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogout,
                child: const Text('Logout'),
              ),
            ] else
              FilledButton.icon(
                onPressed: _handleLogin,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with MKDC'),
              )
          ],
        ),
      ),
    );
  }
}
