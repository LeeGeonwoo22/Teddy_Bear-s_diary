import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teddyBear/features/auth/bloc/auth_bloc.dart';
import 'package:teddyBear/features/auth/bloc/auth_state.dart';
import 'bloc/auth_event.dart';
import '../../core/widgets/custom_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.type != curr.type,
      listener: (context, state) {
        if (state.type == AuthType.guest || state.type == AuthType.social) {
          context.go('/chat');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // ✅ 1️⃣ 로딩 화면
          if (state.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.brown),
              ),
            );
          }

          // ✅ 2️⃣ 로그인 전 (initial)
          if (state.type == AuthType.initial) {
            return Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/3.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 상단 장식
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('✨', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 12),
                            Text('🌸', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 12),
                            Text('✨', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 40),

                      // 로그인 버튼
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.1,
                        ),
                        child: Column(
                          children: [
                            CustomBtn(
                              onTap: () {
                                context.read<AuthBloc>().add(LoginWithGoogle());
                              },
                              text: '구글 로그인',
                              icon: Icons.mail_outline,
                            ),
                            const SizedBox(height: 16),
                            CustomBtn(
                              onTap: () {
                                print('시작');
                                context.read<AuthBloc>().add(LoginAsGuest());
                              },
                              text: '시작',
                              icon: Icons.phone_android_outlined,
                            ),
                          ],
                        ),
                      ),

                      // 하단 장식
                      const Padding(
                        padding: EdgeInsets.only(bottom: 40, top: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🌼', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 16),
                                Text('✨', style: TextStyle(fontSize: 20)),
                                SizedBox(width: 16),
                                Text('🌼', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              '매일 곰돌이와 함께하는 작은 일기',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFC4A57B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // ✅ 3️⃣ 그 외 상태 (게스트 or 소셜 — 이미 Chat으로 이동 예정)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

