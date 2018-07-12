import 'dart:async';
import 'package:angel_client/base_angel_client.dart';
import 'package:angel_http_exception/angel_http_exception.dart';
import 'package:dart2_constant/convert.dart';

/// A simple API for accessing the MyAPI microservice gateway.
class MyApiGatewayClient {
  final BaseAngelClient app;

  MyApiGatewayClient(this.app);

  Future authenticate(String clientId, String clientSecret) async {
    var response = await app.post(
      '/auth/local',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: json.encode({
        'client_id': clientId,
        'client_secret': clientSecret,
      }),
    );

    return app.authToken = json.decode(response.body);
  }

  /// Query the API gateway for the URL of another microservice.
  Future<String> getEndpoint(String scope) async {
    var uri = new Uri(
      path: '/api/endpoints',
      queryParameters: {
        'scope': scope,
      },
    );

    var response = await app.get(uri.toString());

    if (response.statusCode != 200) {
      throw new AngelHttpException.fromJson(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  /// Gets the list of permitted scopes for a [jwt] token.
  Future<List> getScopesForToken(String jwt) async {
    var response = await app.client.post(
      '${app.basePath}/api/auth/revive',
      headers: {
        'accept': 'application/json',
        'authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode != 200) {
      throw new AngelHttpException.fromJson(response.body);
    } else {
      var data = json.decode(response.body);
      return data['data']['scopes'] as List;
    }
  }

  /// Ensures that a [jwt] permits the use of *all* the given [scopes], or throws a 403.
  Future ensureTokenCanAccessScopes(String jwt, Iterable<String> scopes) async {
    var permittedScopes = await getScopesForToken(jwt);

    if (!scopes.every(permittedScopes.contains)) {
      throw new AngelHttpException.forbidden();
    }
  }
}
