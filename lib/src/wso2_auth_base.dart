part of wso2_auth;

createIdentityUriWith({
  String? scheme,
  String? host,
  int? port,
  Iterable<String>? pathSegments,
  Map<String, dynamic>? queryParameters,
}) {
  return Uri(
    scheme: scheme,
    host: host,
    port: port,
    pathSegments: pathSegments,
    queryParameters: queryParameters,
  );
}

class Wso2Auth {
  final String? scheme;
  final String? host;
  final int? port;
  final String clientId;
  final String clientSecret;
  final String authEndpointPath;
  final String tokenEndpointPath;
  final String? logoutEndointPath;
  final String redirectUri;
  final String scopes;
  Wso2Auth({
    this.scheme = 'https',
    required this.host,
    this.port,
    required this.clientId,
    required this.clientSecret,
    required this.authEndpointPath,
    required this.tokenEndpointPath,
    required this.logoutEndointPath,
    required this.redirectUri,
    required this.scopes,
  });

  static const _accessTokenKey = 'accessToken';
  final _storage = const FlutterSecureStorage();

  Future<String?> obtainAccessToken(String code) async {
    final tokenEndpointUri = createIdentityUriWith(
      scheme: scheme,
      host: host,
      port: port,
      pathSegments: tokenEndpointPath.split('/'),
    );

    final response = await http.post(
      tokenEndpointUri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        await saveAccessToken(accessToken);
        return accessToken;
      }
    } else {
      debugPrint(
          'Error obtaining access token: ${response.statusCode} ${response.body}');
    }
    return null;
  }

  Future<String?> login(BuildContext context) async {
    final authEndpointUri = createIdentityUriWith(
      scheme: scheme,
      host: host,
      port: port,
      pathSegments: authEndpointPath.split('/'),
      queryParameters: {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes
      },
    );

    return await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (context) => AuthView(
          initialUri: authEndpointUri,
          onCodeReceived: (code) {
            obtainAccessToken(code).then(
              (value) => Navigator.of(context).pop(value),
            );
          },
        ),
      ),
    );
  }

  Future<bool> logout(BuildContext context) async {
    final logoutEndpointUri = createIdentityUriWith(
      scheme: scheme,
      host: host,
      port: port,
      pathSegments: logoutEndointPath?.split('/'),
      queryParameters: {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes
      },
    );
    return await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AuthView(
          initialUri: logoutEndpointUri,
          onPageFinished: (url) {
            if (url.contains('oauth2_logout.do')) {
              Navigator.of(context).pop(true);
            } else if (url.contains('oauth2_error.do')) {
              Navigator.of(context).pop(false);
            }
          },
        ),
      ),
    ).then((value) {
      if (value ?? false) {
        _storage.delete(key: _accessTokenKey);
        return true;
      }
      return false;
    });
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  Future<bool> hasCachedAccountInformation() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null;
  }
}
