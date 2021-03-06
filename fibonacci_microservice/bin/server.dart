import 'dart:io';
import 'dart:isolate';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_client/io.dart' show Rest;
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/local.dart';
import 'package:my_api/my_api.dart';
import 'package:my_api_client/my_api_client.dart';
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
  var fs = const LocalFileSystem();

  hierarchicalLoggingEnabled = true;
  app.logger = new Logger('fibonacci')..onRecord.listen(prettyLog);

  app.configure(configuration(fs)).then((_) async {
    var auth = new AngelAuth();
    var client = new MyApiGatewayClient(new Rest(app.configuration['gateway']));

    // We'll have only ONE route, which performs the Fibonacci.
    app.get('/:index', (String index, RequestContext req) async {
      var jwt = auth.getJwt(req);

      if (jwt == null) {
        throw new AngelHttpException.forbidden();
      }

      // Ensure the client can perform a fibonacci.
      await client.ensureTokenCanAccessScopes(
        jwt,
        [MyApiScopes.performFibonacci],
      );

      return fibonacci(int.parse(index));
    });

    var server = await http.startServer('127.0.0.1', 3001);
    var uri = Uri.parse('http://${server.address.address}:${server.port}');
    print('Fibonacci service isolate #$isolateId listening at $uri');
  });
}

int fibonacci(int index) {
  if (index <= 1) {
    return index;
  } else {
    return fibonacci(index - 1) + fibonacci(index - 2);
  }
}
