/// Declare services here!
library my_api_auth.services;

import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';
import 'client.dart' as client;

/// Configure our application to use *services*.
/// Services must be wired to the app via `app.use`.
///
/// They provide many benefits, such as instant REST API generation,
/// and respond to both REST and WebSockets.
///
/// Read more here:
/// https://github.com/angel-dart/angel/wiki/Service-Basics
AngelConfigurer configureServer(FileSystem fs) {
  return (Angel app) async {
    var dbDirectory = fs.directory('.db');
    await dbDirectory.create(recursive: true);
    await app.configure(client.configureServer(dbDirectory));
  };
}
