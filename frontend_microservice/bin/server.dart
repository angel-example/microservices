import 'dart:io';
import 'dart:isolate';
import 'package:angel_client/io.dart' show Rest;
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_static/angel_static.dart';
import 'package:dart2_constant/convert.dart';
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
    var client = new MyApiGatewayClient(new Rest(app.configuration['gateway']));
    String fibonacciEndpoint, sqrtEndpoint;

    // A single endpoint that performs the computation.
    app.post('/api/compute', (RequestContext req) async {
      // Authenticate against the API gateway for the first time, if we haven't already.
      if (client.app.authToken == null) {
        await client.authenticate(
            app.configuration['id'], app.configuration['secret']);

        fibonacciEndpoint ??=
            await client.getEndpoint(MyApiScopes.performFibonacci);

        sqrtEndpoint ??=
            await client.getEndpoint(MyApiScopes.performSquareRoot);
      }

      var n = req.body['n'] as num;
      var sqrt = await client.app.client
          .get('$sqrtEndpoint/$n')
          .then((r) => r.body)
          .then(json.decode) as num;

      var index = sqrt.toInt();
      var fib = await client.app.client
          .get('$fibonacciEndpoint/$index')
          .then((r) => r.body)
          .then(json.decode) as int;
      return fib;
    });

    var vDir = new VirtualDirectory(app, fs, source: fs.directory('web'));
    app.use(vDir.handleRequest);

    var server = await http.startServer('127.0.0.1', 3003);
    var uri = Uri.parse('http://${server.address.address}:${server.port}');
    print('Frontend service isolate #$isolateId listening at $uri');
  });
}
