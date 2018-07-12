// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_api_client.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class MyApiClientSerializer {
  static MyApiClient fromMap(Map map) {
    return new MyApiClient(
        id: map['id'] as String,
        name: map['name'] as String,
        clientId: map['client_id'] as String,
        hashedClientSecret: map['hashed_client_secret'] as String,
        salt: map['salt'] as String,
        scopes: map['scopes'] as List<String>,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(MyApiClient model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'name': model.name,
      'client_id': model.clientId,
      'hashed_client_secret': model.hashedClientSecret,
      'salt': model.salt,
      'scopes': model.scopes,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class MyApiClientFields {
  static const List<String> allFields = const <String>[
    id,
    name,
    clientId,
    hashedClientSecret,
    salt,
    scopes,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String name = 'name';

  static const String clientId = 'client_id';

  static const String hashedClientSecret = 'hashed_client_secret';

  static const String salt = 'salt';

  static const String scopes = 'scopes';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
