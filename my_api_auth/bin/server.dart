import 'dart:io';
import 'dart:isolate';
import 'package:my_api_auth/src/pretty_logging.dart';
import 'package:my_api_auth/my_api_auth.dart' as my_api_auth;
import 'package:angel_framework/angel_framework.dart';
import 'package:logging/logging.dart';

void main() {
  for (int i = 1; i < Platform.numberOfProcessors; i++) {
    Isolate.spawn(serverMain, i);
  }

  serverMain(0);
}

void serverMain(int isolateId) {
  var app = new Angel()..lazyParseBodies = true;
  var http = new AngelHttp.custom(app, startShared);

  hierarchicalLoggingEnabled = true;
  app.logger = new Logger('my_api_auth')..onRecord.listen(prettyLog);

  app.configure(my_api_auth.configureServer).then((_) async {
    var server = await http.startServer('127.0.0.1', 3000);
    var uri = Uri.parse('http://${server.address.address}:${server.port}');
    print('Auth service isolate #$isolateId listening at $uri');
  });
}
