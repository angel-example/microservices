# my_api_auth
This microservice is responsible for keeping track of registered clients,
and delegating access via JWT: https://github.com/angel-dart/auth

Because this is just an example project, no database is used, because not everyone
will have the same software installed locally.

Instead, `package:angel_file_service` is used as make-shift database that persists
to a single JSON file.

## Registering a Client
To register a new client, use `bin/register.dart`.
This will provide you with a client ID and client secret.

The client secret is hashed immediately, and the plaintext version
is **never** stored in the database, so be sure to save it!

```
Registering a new client with the following information:
  * Name: Frontend
  * Client ID: 97041f56-d097-4890-8873-168c6c341eef
  * Client Secret: 9e1c11e1-8baf-4813-ba20-105c5f35b8d9
  * Scopes: [square_root, fibonacci]
Really register this client (cannot be undone)? (y/N): y
WARNING: Failed to reload contents of .db/clients.json.
Successfully registed client Frontend!

Make sure to write down your client secret, as it CANNOT BE RECOVERED!!!
```

## Running the Server
It's simple: just call `ANGEL_ENV=production dart bin/server.dart`.