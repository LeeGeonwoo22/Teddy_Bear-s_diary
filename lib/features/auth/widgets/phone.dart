import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  void _sendCode() async {
    setState(() => _loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _showMessage('자동 로그인 완료');
        context.go('/navbar');
      },
      verificationFailed: (FirebaseAuthException e) {
        _showMessage('인증 실패: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
        _showMessage('인증 코드가 전송되었습니다.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    setState(() => _loading = false);
  }

  void _verifyCode() async {
    if (_verificationId == null) return;

    setState(() => _loading = true);

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeController.text.trim(),
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _showMessage('로그인 성공');
    } catch (e) {
      _showMessage('코드 인증 실패');
    }

    setState(() => _loading = false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('전화번호 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (!_codeSent)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: '전화번호 입력 (+82...)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            if (_codeSent)
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: '인증 코드 입력',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _codeSent ? _verifyCode : _sendCode,
              child: Text(_codeSent ? '코드 인증하기' : '인증 코드 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}