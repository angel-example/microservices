import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
part 'my_api_client.g.dart';
part 'my_api_client.serializer.g.dart';

String hashClientSecret(String clientSecret, String salt, String pepper) {
  var bytes = sha256.convert('$salt:$clientSecret.$pepper'.codeUnits).bytes;
  return hex.encode(bytes);
}

@serializable
abstract class _MyApiClient extends Model {
  String get name;

  String get clientId;

  String get hashedClientSecret;

  String get salt;

  List<String> get scopes;
}

abstract class MyApiScopes {
  static const List<String> all = const <String>[performFibonacci];

  static const String performFibonacci = 'fibonacci';
}
