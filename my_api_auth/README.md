# my_api_auth
This microservice is responsible for keeping track of registered clients,
and delegating access via OAuth2: https://github.com/angel-dart/oauth2

Because this is just an example project, no database is used, because not everyone
will have the same software installed locally.

Instead, `package:angel_file_service` is used as make-shift database that persists
to a single JSON file.

## Registering a Client
To register a new OAuth2 client, use `bin/register.dart`.

## Running the Server
It's simple: just call `ANGEL_ENV=production dart bin/server.dart`.