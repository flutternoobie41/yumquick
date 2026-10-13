import 'package:json_annotation/json_annotation.dart';
import 'package:yum_quick/features/auth/domain/entity/user.dart';


part 'user_model.g.dart';

/// User as returned by DummyJSON `/auth/login` and `/auth/me`.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final int id;
  final String username;

  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(defaultValue: '')
  final String firstName;

  @JsonKey(defaultValue: '')
  final String lastName;

  final String? image;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
        id: id,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        imageUrl: image,
      );
}

/// Body of a successful `POST /auth/login`: the user plus its tokens.
///
/// DummyJSON puts the user fields and the tokens side by side at the top
/// level, so [user] is read from the whole object rather than a `user` key.
@JsonSerializable(createToJson: false)
class LoginResponseModel {
  const LoginResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  @JsonKey(readValue: _readRoot)
  final UserModel user;

  final String accessToken;
  final String? refreshToken;
}

/// Hands the whole JSON object to [UserModel.fromJson].
Object? _readRoot(Map<dynamic, dynamic> json, String key) => json;