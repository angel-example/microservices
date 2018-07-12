import 'package:angel_framework/angel_framework.dart';
import 'package:my_api/my_api.dart';
import 'package:my_api_auth/my_api_auth.dart' as my_api_auth;
import 'package:my_api_auth/models.dart';
import 'package:prompts/prompts.dart' as prompts;
import 'package:uuid/uuid.dart';

main() async {
  var uuid = new Uuid();
  var name = prompts.get('Name of client');
  var clientId = uuid.v4().toString(),
      clientSecret = uuid.v4().toString(),
      salt = uuid.v4().toString();
  var scopes = <String>[];

  while (true) {
    if (!prompts.getBool('$name has ${scopes.length} scope(s). Add another?')) {
      break;
    } else {
      var scope = prompts.choose('Choose an API to enable', MyApiScopes.all);

      if (!scopes.contains(scope)) {
        scopes.add(scope);
        print('Added scope `$scope`');
      } else {
        print('The scope `$scope` is already enabled.');
      }
    }
  }

  var app = new Angel();
  await app.configure(my_api_auth.configureServer);

  var pepper = app.configuration['jwt_secret'] as String;

  print('''
Registering a new client with the following information:
  * Name: $name
  * Client ID: $clientId
  * Client Secret: $clientSecret
  * Scopes: $scopes
  '''
      .trim());

  if (!prompts.getBool('Really register this client (cannot be undone)?')) {
    print('Cancelled');
  } else {
    var hashed = hashClientSecret(clientSecret, salt, pepper);
    var client = new MyApiClient(
      name: name,
      clientId: clientId,
      hashedClientSecret: hashed,
      salt: salt,
      scopes: scopes,
    );

    await app.service('api/clients').create(client.toJson());

    print(
        'Successfully registed client $name!\n\nMake sure to write down your client secret, as it CANNOT BE RECOVERED!!!');
  }
}
