import 'package:angel_file_service/angel_file_service.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_validate/server.dart';
import 'package:file/file.dart';
import 'package:my_api_auth/models.dart';

AngelConfigurer configureServer(Directory dbDirectory) {
  return (app) async {
    // Create a service which reads from/writes to a JSON file.
    var service = app.use('/api/clients',
            new JsonFileService(dbDirectory.childFile('clients.json')))
        as HookedService;

    // However, only this server should be able to access its contents,
    // so we use `hooks.disable()` to completely deny Internet access to it,
    // even from authenticated clients.
    service.beforeAll(hooks.disable());

    // We'll use a `Validator` to sanitize incoming input, regardless of the fact
    // that only the server is touching it.
    var stringKeys = [
      MyApiClientFields.name,
      MyApiClientFields.clientId,
      MyApiClientFields.hashedClientSecret,
      MyApiClientFields.salt
    ];

    var createService = new Validator({
      // Make sure that `name`, `client_id`, `hashed_client_secret`, and `salt` are present.
      requireFields(stringKeys): isNonEmptyString,

      // Ensure that `scopes` is present, and that every element is a valid scope.
      requireField(MyApiClientFields.scopes): [
        isList,
        everyElement(isIn(MyApiScopes.all))
      ]
    });

    // Require newly-created services to adhere to the scheme we defined above.
    service.beforeCreated.listen(validateEvent(createService));

    // Insert a `created_at` timestamp on creation.
    service.beforeCreated.listen(hooks.addCreatedAt(key: 'created_at'));

    // Insert an `updated_at` timestamp on `create`, `modify`, and `update`.
    service.beforeModify(hooks.addUpdatedAt(key: 'updated_at'));
  };
}
