// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_api_client.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class MyApiClient extends _MyApiClient {
  MyApiClient(
      {this.id,
      this.name,
      this.clientId,
      this.hashedClientSecret,
      this.salt,
      List<String> scopes,
      this.createdAt,
      this.updatedAt})
      : this.scopes = new List.unmodifiable(scopes ?? []);

  @override
  final String id;

  @override
  final String name;

  @override
  final String clientId;

  @override
  final String hashedClientSecret;

  @override
  final String salt;

  @override
  final List<String> scopes;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  MyApiClient copyWith(
      {String id,
      String name,
      String clientId,
      String hashedClientSecret,
      String salt,
      List<String> scopes,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new MyApiClient(
        id: id ?? this.id,
        name: name ?? this.name,
        clientId: clientId ?? this.clientId,
        hashedClientSecret: hashedClientSecret ?? this.hashedClientSecret,
        salt: salt ?? this.salt,
        scopes: scopes ?? this.scopes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _MyApiClient &&
        other.id == id &&
        other.name == name &&
        other.clientId == clientId &&
        other.hashedClientSecret == hashedClientSecret &&
        other.salt == salt &&
        const ListEquality<String>(const DefaultEquality<String>())
            .equals(other.scopes, scopes) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  Map<String, dynamic> toJson() {
    return MyApiClientSerializer.toMap(this);
  }
}
