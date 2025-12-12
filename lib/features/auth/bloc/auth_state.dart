import 'package:equatable/equatable.dart';
import '../../../data/model/user_model.dart';

enum AuthType { initial, guest, social, loading }

class AuthState extends Equatable {
  final User? user;
  final String? uuid;
  final AuthType type;
  final String? error;

  const AuthState({
    this.user,
    this.uuid,
    required this.type,
    this.error,
  });

  factory AuthState.initial() => const AuthState(
    type: AuthType.initial,
  );

  factory AuthState.guest(String uuid, User user) => AuthState(
    user: user,
    uuid: uuid,
    type: AuthType.guest,
  );

  factory AuthState.social({
    required String uuid,
    required User user,
  }) =>
      AuthState(
        user: user,
        uuid: uuid,
        type: AuthType.social,
      );

  factory AuthState.loading() => const AuthState(
    type: AuthType.loading,
  );

  @override
  List<Object?> get props => [user, uuid, type, error];

  AuthState copyWith({
    User? user,
    String? uuid,
    AuthType? type,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      error: error ?? this.error,
    );
  }

  bool get isGuest => type == AuthType.guest;
  bool get isSocial => type == AuthType.social;
  bool get isLoading => type == AuthType.loading;
}