/// This app's route configuration.
library my_api_auth.src.routes;

import 'dart:async';

import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';
import 'package:my_api_auth/models.dart';

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://github.com/angel-dart/angel/wiki/Basic-Routing
/// * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Mount a single route at /api/endpoints:
    //   * Requires JWT authentication.
    //   * Ensures that the authenticated client has permission to a scope.
    //   * If so, return the HTTP URL of the microservice corresponding to said scope.
    app.get(
      '/api/endpoints',
      waterfall([
        requireAuthentication(userKey: 'client'),
        getEndpointForScope,
      ]),
    );

    // Throw a 404 if no route matched the request.
    app.use(() => throw new AngelHttpException.notFound());
  };
}

Future<String> getEndpointForScope(
    MyApiClient client, RequestContext req) async {
  var endpoints = req.app.configuration['endpoints'] as Map;
  var scope = req.query['scope']?.toString() ?? '';

  // Ensure that `scope` is present in the query.
  if (scope.trim().isEmpty) {
    throw new AngelHttpException.badRequest();
  }

  // If the client's scope doesn't allow accessing a given microservice,
  // then throw a 403.
  if (!client.scopes.contains(scope)) {
    throw new AngelHttpException.forbidden();
  }

  if (!endpoints.containsKey(scope)) {
    throw new AngelHttpException.notFound();
  }

  return endpoints[scope] as String;
}
