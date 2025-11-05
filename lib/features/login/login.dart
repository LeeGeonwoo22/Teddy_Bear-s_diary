import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/google.dart';
import '../../widgets/custom_btn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // context.go('/login'); // splash 다음 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // 가로 꽉 채우기
        height: double.infinity, // 세로 꽉 채우기
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFDF8E),
              Color(0xFFFEE290),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                "assets/images/img.png",
                fit: BoxFit.cover, // 이미지 빈공간 없이 꽉 채우기
                width: double.infinity,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Teddy Bear's Diary",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomBtn(
                      onTap: () {
                        GoogleSignInService.signInWithGoogle();
                      },
                      text: '구글 로그인',
                    ),
                    const SizedBox(height: 16),
                    CustomBtn(
                      onTap: () {
                        print('휴대폰 로그인');
                        // PhoneLoginScreen();
                        context.go('/phone-login');
                      },
                      text: '휴대폰 로그인',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
