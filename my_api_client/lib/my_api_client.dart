import 'dart:async';
import 'package:angel_client/angel_client.dart';
import 'package:dart2_constant/convert.dart';

/// A simple API for accessing the MyAPI microservice gateway.
class MyApiGatewayClient {
  final Angel app;

  MyApiGatewayClient(this.app);

  Future authenticate(String clientId, String clientSecret) {
    return app.authenticate(
      type: 'local',
      credentials: {
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );
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
}
