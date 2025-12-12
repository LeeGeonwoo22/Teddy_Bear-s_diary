import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// 앱 시작 시 (비회원 자동 로그인)
class AppStarted extends AuthEvent {}

/// 소셜 로그인 시도 (예: Google)
class LoginWithSocial extends AuthEvent {
  final String name;
  final String email;
  final String provider; // google, facebook, apple 등

  const LoginWithSocial({
    required this.name,
    required this.email,
    required this.provider,
  });

  @override
  List<Object?> get props => [name, email, provider];
}

/// 비회원 데이터 리셋 (UUID 포함)
class ResetGuest extends AuthEvent {}
