/// Your very own web application!
library my_api_auth;

import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/local.dart';
import 'src/auth.dart' as auth;
import 'src/config/config.dart' as configuration;
import 'src/routes/routes.dart' as routes;
import 'src/services/services.dart' as services;

/// Configures the server instance.
Future configureServer(Angel app) async {
  // Grab a handle to the file system, so that we can do things like
  // serve static files.
  var fs = const LocalFileSystem();

  // Read the application configuration.
  await app.configure(configuration.configureServer(fs));

  // Set up our application, using the plug-ins defined with this project.
  await app.configure(auth.configureServer);
  await app.configure(services.configureServer(fs));
  await app.configure(routes.configureServer(fs));
}
