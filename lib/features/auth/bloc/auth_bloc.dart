import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/user.dart' as app_user;
import '../repository/AuthRepository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LoginAsGuest>(_onLoginAsGuest);
    on<ResetGuest>(_onResetGuest);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// 앱이 처음 실행될 때 - 기존 로그인 상태 확인
  Future<void> _onAppStarted(
      AppStarted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    try {
      final currentUser = _authRepository.getCurrentUser();

      if (currentUser == null) {
        // 로그인 상태 아님 - 로그인 페이지로
        emit(AuthState.initial());
        return;
      }

      // Firestore에서 사용자 데이터 가져오기
      final userData = await _authRepository.getUserData(currentUser.uid);

      if (userData == null) {
        // 데이터 없음 - 로그아웃 처리
        await _authRepository.signOut();
        emit(AuthState.initial());
        return;
      }

      final user = app_user.User.fromJson(userData);

      if (user.isGuest) {
        emit(AuthState.guest(user.uuid, user));
      } else {
        emit(AuthState.social(uuid: user.uuid, user: user));
      }
    } catch (e) {
      print('AppStarted error: $e');
      emit(AuthState.initial());
    }
  }

  /// 비회원 로그인
  Future<void> _onLoginAsGuest(
      LoginAsGuest event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    try {
      final userCredential = await _authRepository.guestLogin();

      if (userCredential?.user == null) {
        throw Exception('비회원 로그인 실패');
      }

      final firebaseUid = userCredential!.user!.uid;
      final guestUser = app_user.User.guest(uuid: firebaseUid);

      emit(AuthState.guest(firebaseUid, guestUser));
    } catch (e) {
      emit(state.copyWith(
        type: AuthType.initial,
        error: '비회원 로그인 실패: $e',
      ));
    }
  }

  /// 소셜 로그인 구글
  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    try {
      // 현재 비회원 UUID 저장 (있다면)
      final previousGuestUid = state.isGuest ? state.uuid : null;

      // 소셜 로그인 실행
      final userCredential = await _authRepository.signInWithGoogle();

      if (userCredential?.user == null) {
        throw Exception('소셜 로그인 실패');
      }

      final firebaseUser = userCredential!.user!;
      final firebaseUid = firebaseUser.uid;

      // Firestore에서 기존 데이터 확인
      final existingData = await _authRepository.getUserData(firebaseUid);

      app_user.User socialUser;

      if (existingData != null) {
        // 이미 가입된 소셜 계정
        socialUser = app_user.User.fromJson(existingData);
      } else {
        // 신규 소셜 계정
        socialUser = app_user.User.social(
          uuid: firebaseUid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          provider: 'google',
        );

        // Firestore에 저장
        await _authRepository.updateUserData(firebaseUid, socialUser.toJson());
      }

      // 비회원에서 전환된 경우 데이터 마이그레이션
      if (previousGuestUid != null && previousGuestUid != firebaseUid) {
        await _authRepository.migrateGuestData(
          guestUid: previousGuestUid,
          socialUid: firebaseUid,
        );
      }

      emit(AuthState.social(uuid: firebaseUid, user: socialUser));
    } catch (e) {
      print('LoginWithSocial error: $e');
      emit(state.copyWith(
        type: state.type == AuthType.guest ? AuthType.guest : AuthType.initial,
        error: '로그인 실패: $e',
      ));
    }
  }

  // 로그아웃
  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    try {
      await _authRepository.signOut();
      emit(AuthState.initial());
    } catch (e) {
      print('Logout error: $e');
      emit(state.copyWith(
        error: '로그아웃 실패: $e',
      ));
    }
  }

  /// 비회원 데이터 리셋
  Future<void> _onResetGuest(
      ResetGuest event,
      Emitter<AuthState> emit,
      ) async {
    if (!state.isGuest) return;

    emit(AuthState.loading());

    try {
      // 현재 비회원 계정 로그아웃
      await _authRepository.signOut();

      // 새 비회원 계정으로 로그인
      final userCredential = await _authRepository.guestLogin();

      if (userCredential?.user == null) {
        throw Exception('비회원 재생성 실패');
      }

      final firebaseUid = userCredential!.user!.uid;
      final newGuest = app_user.User.guest(uuid: firebaseUid);

      emit(AuthState.guest(firebaseUid, newGuest));
    } catch (e) {
      emit(state.copyWith(
        error: '리셋 실패: $e',
      ));
    }
  }
}