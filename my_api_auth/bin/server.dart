import 'package:my_api_auth/src/pretty_logging.dart';
import 'package:my_api_auth/my_api_auth.dart' as my_api_auth;
import 'package:angel_framework/angel_framework.dart';
import 'package:logging/logging.dart';

main() async {
  // Watch the config/ and web/ directories for changes, and hot-reload the server.
  var app = new Angel()..lazyParseBodies = true;
  var http = new AngelHttp(app);
  await app.configure(my_api_auth.configureServer);
  hierarchicalLoggingEnabled = true;
  app.logger = new Logger('my_api_auth');
  var sub = app.logger.onRecord.listen(prettyLog);
  app.shutdownHooks.add((_) => sub.cancel());

  var server = await http.startServer('127.0.0.1', 3001);
  print(
      'Auth service listening at http://${server.address.address}:${server.port}');
}
