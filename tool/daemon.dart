import 'dart:async';
import 'dart:io';

main() async {
  startDartProcess('my_api_auth');
  startDartProcess('fibonacci_microservice');
  startDartProcess('sqrt_microservice');
  startDartProcess('frontend_microservice');
}

/// Spawns a Dart process, and respawns it on death.
Future startDartProcess(String name) {
  var p = Process.start(
    Platform.resolvedExecutable,
    ['bin/server.dart'],
    workingDirectory: name,
  );

  return p.then((p) {
    p.stdout.listen(stdout.add);
    p.stderr.listen(stderr.add);
    return p.exitCode.then((_) {
      print('Server $name died. Restarting...');
      return startDartProcess(name);
    });
  });
}
