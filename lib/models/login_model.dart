import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

//modelo de json para la ruta /auth/login

@JsonSerializable()
class LoginRequest {
  final String grupo;
  final String numero;
  final String username;
  final String password;

  LoginRequest({
    required this.grupo,
    required this.numero,
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

//modelos de respuesta para ruta /auth/login

@JsonSerializable()
class Token {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() {
    return 'Token(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType)';
  }
}

// modelos de respuesta de ruta /auth/logout
class LogoutResponse {
  final String message;

  LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String,
    );
  }
}

// modelos de respuesta para ruta /screen-groups/:userId
class ScreenGroup {
  final int id;
  final String name;
  final String identifier;

  ScreenGroup({required this.id, required this.name, required this.identifier});

  factory ScreenGroup.fromJson(Map<String, dynamic> json) {
    return ScreenGroup(
      id: json['id'],
      name: json['name'],
      identifier: json['identifier'],
    );
  }
}

class UserScreenGroupsResponse {
  final int userId;
  final List<ScreenGroup> screenGroups;

  UserScreenGroupsResponse({required this.userId, required this.screenGroups});

  factory UserScreenGroupsResponse.fromJson(Map<String, dynamic> json) {
    return UserScreenGroupsResponse(
      userId: json['user_id'],
      screenGroups: (json['screen_groups'] as List)
          .map((group) => ScreenGroup.fromJson(group))
          .toList(),
    );
  }
}
