/// This app's route configuration.
library my_api_auth.src.routes;

import 'package:angel_cors/angel_cors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';
import 'controllers/controllers.dart' as controllers;

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://github.com/angel-dart/angel/wiki/Basic-Routing
/// * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Enable CORS
    app.use(cors());

    // Typically, you want to mount controllers first, after any global middleware.
    await app.configure(controllers.configureServer);

    // Throw a 404 if no route matched the request.
    app.use(() => throw new AngelHttpException.notFound());
  };
}
