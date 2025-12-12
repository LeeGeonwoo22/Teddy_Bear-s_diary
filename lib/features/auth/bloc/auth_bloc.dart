import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginWithSocial>(_onLoginWithSocial);
    on<ResetGuest>(_onResetGuest);
  }

  /// 앱이 처음 실행될 때
  Future<void> _onAppStarted(
      AppStarted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    // 매번 새로운 UUID 생성
    final uuid = const Uuid().v4();
    final guest = User.guest(uuid);

    // TODO: SharedPreferences에서 기존 UUID 확인
    // final savedUuid = await _storage.getUuid();
    // if (savedUuid != null) {
    //   final guest = User.guest(savedUuid);
    //   emit(AuthState.guest(savedUuid, guest));
    //   return;
    // }

    // TODO: 새 UUID를 저장
    // await _storage.saveUuid(uuid);

    emit(AuthState.guest(uuid, guest));
  }

  /// 소셜 로그인 시
  Future<void> _onLoginWithSocial(
      LoginWithSocial event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState.loading());

    try {
      final guestUuid = state.uuid ?? const Uuid().v4();

      final socialUser = User.social(
        uuid: guestUuid,
        name: event.name,
        email: event.email,
        provider: event.provider,
      );

      // TODO: 서버에 UUID와 소셜 계정 연결
      // await _authRepository.linkSocialAccount(
      //   uuid: guestUuid,
      //   socialId: event.email,
      //   provider: event.provider,
      // );

      emit(AuthState.social(uuid: guestUuid, user: socialUser));
    } catch (e) {
      emit(state.copyWith(
        type: AuthType.guest,
        error: '로그인 실패: $e',
      ));
    }
  }

  /// 비회원 데이터 리셋 (새로운 UUID 생성)
  Future<void> _onResetGuest(
      ResetGuest event,
      Emitter<AuthState> emit,
      ) async {
    if (!state.isGuest) return; // 게스트일 때만 리셋 가능

    emit(AuthState.loading());

    // TODO: 로컬 데이터 삭제
    // await _storage.clearChatHistory();
    // await _storage.clearUuid();

    // 새로운 UUID로 재시작
    final newUuid = const Uuid().v4();
    final newGuest = User.guest(newUuid);

    // TODO: 새 UUID 저장
    // await _storage.saveUuid(newUuid);

    emit(AuthState.guest(newUuid, newGuest));
  }
}