/// This app's route configuration.
library my_api_auth.src.routes;

import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://github.com/angel-dart/angel/wiki/Basic-Routing
/// * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Throw a 404 if no route matched the request.
    app.use(() => throw new AngelHttpException.notFound());
  };
}
