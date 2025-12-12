import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teddyBear/features/auth/bloc/auth_bloc.dart';
import 'package:teddyBear/features/auth/bloc/auth_state.dart';
import '../../auth/google.dart';
import '../../core/widgets/custom_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Timer는 여기서 필요 없을 것 같아요 (로그인 화면이니까)
    // Splash 화면이라면 다른 페이지로 분리하는 게 좋아요
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
// 비회원 로그인시 채팅창으로 이동됨.
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.type == AuthType.guest) {
          context.go('/chat');
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // 배경 이미지를 BoxDecoration으로 변경
            image: DecorationImage(
              image: AssetImage("assets/images/3.png"),
              fit: BoxFit.cover, // 화면 꽉 채우기
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 상단 장식 (선택사항)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
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

                Spacer(),

                // 환영 메시지 박스 추가
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 40),
                //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.5),
                //     borderRadius: BorderRadius.circular(20),
                //     border: Border.all(
                //       color: Color(0xFFC4A57B).withOpacity(0.3),
                //       width: 1,
                //     ),
                //   ),
                //   child: Column(
                //     children: [
                //       Text(
                //         '안녕! 오늘 하루는 어땠니?',
                //         style: TextStyle(
                //           fontSize: 15,
                //           color: Color(0xFF8B6F47),
                //           fontWeight: FontWeight.w500,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //       SizedBox(height: 4),
                //       Text(
                //         '나에게 이야기를 들려줘 💛',
                //         style: TextStyle(
                //           fontSize: 13,
                //           color: Color(0xFFA89070),
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(height: 40),

                // 버튼들
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width * 0.1, // 화면 너비의 10%씩 여백
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context,state) {
                      // final isLoading = state.type == AuthType.loading;
                      return Column(
                        children: [
                          CustomBtn(
                            onTap: () {
                              GoogleSignInService.signInWithGoogle();
                            },
                            text: '구글 로그인',
                            icon: Icons.mail_outline, // 아이콘 추가
                          ),
                          const SizedBox(height: 16),
                          CustomBtn(
                            onTap: () {
                              print('시작');
                              context.go('/chat');
                            },
                            text: '시작',
                            icon: Icons.phone_android_outlined, // 아이콘 추가
                          ),
                        ],
                      );
                    }

                  ),
                ),

                // 하단 여백 + 장식
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 30),
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
      ),
    );
  }
}