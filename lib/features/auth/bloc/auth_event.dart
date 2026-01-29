import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// 앱 시작 시 (비회원 자동 로그인)
class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginAsGuest extends AuthEvent {
  const LoginAsGuest();
}


class LoginWithGoogle extends AuthEvent {
  const LoginWithGoogle();
}

class LoginWithApple extends AuthEvent {
  const LoginWithApple();
}

class LoginWithFacebook extends AuthEvent {
  const LoginWithFacebook();
}

/// 로그아웃 버튼 클릭
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// 소셜 로그인 시도 (예: Google)
// class LoginWithGoogle extends AuthEvent {
//   final String name;
//   final String email;
//   final String provider; // google, facebook, apple 등
//
//   const LoginWithGoogle({
//     required this.name,
//     required this.email,
//     required this.provider,
//   });
//
//   @override
//   List<Object?> get props => [name, email, provider];
// }
//
// class LoginWithFacebook extends AuthEvent {
//   final String name;
//   final String email;
//   final String provider; // google, facebook, apple 등
//
//   const LoginWithFacebook({
//     required this.name,
//     required this.email,
//     required this.provider,
//   });
//
//   @override
//   List<Object?> get props => [name, email, provider];
// }
//
// class LoginWithApple extends AuthEvent {
//   final String name;
//   final String email;
//   final String provider; // google, facebook, apple 등
//
//   const LoginWithApple({
//     required this.name,
//     required this.email,
//     required this.provider,
//   });
//
//   @override
//   List<Object?> get props => [name, email, provider];
// }
/// 비회원 데이터 리셋 (UUID 포함)
class ResetGuest extends AuthEvent {}
