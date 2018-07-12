import 'dart:async';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:my_api_auth/models.dart';

Future configureServer(Angel app) async {
  // Create an authenticator, which will be used to control access to server resources.
  var pepper = app.configuration['jwt_secret'] as String;
  var auth = new AngelAuth<MyApiClient>(
    jwtKey: pepper,
    allowCookie: false,
    userKey: 'client',
  );

  // Mount a global middleware that decodes JWT's.
  app.use(auth.decodeJwt);

  // A function used to associate a JWT token with a given client.
  auth.serializer = (client) => client.clientId;

  // A function used to find the client associated with a given JWT.
  auth.deserializer = (clientId) async {
    var query = {MyApiClientFields.clientId: clientId.toString()};
    var params = {'query': query};
    var map = await app.service('api/clients').findOne(params) as Map;
    return MyApiClientSerializer.fromMap(map);
  };

  // A simple closure that `LocalAuthStrategy` will use to authenticate clients.
  verifier(String clientId, String clientSecret) async {
    // Find the associated client for the client ID.
    var client = await auth.deserializer(clientId);

    if (client != null) {
      var hash = hashClientSecret(clientSecret, client.salt, pepper);

      // Make sure that the client secret provided matches the hashed client secret.
      if (hash != client.hashedClientSecret) {
        return null;
      }
    }

    return client;
  }

  // Tell our authenticator how to authenticate clients who are attempting
  // to log in with a client ID and secret.
  //
  // TIP: By default, `LocalAuthStrategy` also supports Basic authentication:
  // https://en.wikipedia.org/wiki/Basic_access_authentication
  //
  // If you'd rather stick to Basic authentication than JWT authentication,
  // you can use `auth.authenticate('local', new AngelAuthOptions(canRespondWithJson: false))`
  // as a middleware in front of protected routes.
  auth.strategies.add(new LocalAuthStrategy(
    verifier,
    usernameField: 'client_id',
    passwordField: 'client_secret',
  ));

  // Mount a single route that allows clients to receive a JWT from the server.
  app.post(
    '/auth/local',
    auth.authenticate(
      'local',
      new AngelAuthOptions(
        callback: (req, res, jwt) {
          // Usually, `package:angel_auth` will return both the JWT, AND information about the authenticated user.
          // However, in this case, the API clients don't necessarily need to see their own client information, so
          // we'll just return the JWT itself, serialized as JSON.
          res.json(jwt);
        },
      ),
    ),
  );

  // Mount one more route that can be used to revive a JWT.
  //
  // Note that this endpoint inherently also performs validation of JWT's,
  // *AND* returns information about the currently authenticated client.
  //
  // This way, individual microservices can use this authentication microservice
  // to ensure that clients have the necessary access to perform functions.
  app.post('/api/auth/revive', auth.reviveJwt);
}
