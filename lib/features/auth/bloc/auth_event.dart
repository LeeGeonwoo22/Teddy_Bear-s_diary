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

// auth_event.dart
class DeleteAccount extends AuthEvent {
  const DeleteAccount();
}

/// 비회원 데이터 리셋 (UUID 포함)
class ResetGuest extends AuthEvent {}
