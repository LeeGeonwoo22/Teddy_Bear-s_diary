// core/common/encryption_service.dart
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyStorageKey = 'encryption_key';

  // 🔒 싱글톤 패턴
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  enc.Key? _key;
  enc.IV? _iv;
  enc.Encrypter? _encrypter;
  bool _isInitialized = false;

  /// ✅ 명시적 초기화
  Future<void> init() async {
    if (_isInitialized) {
      print('⚠️ 암호화 서비스 이미 초기화됨');
      return;
    }

    print('🔧 암호화 초기화 중...');

    try {
      // 1️⃣ 저장된 키 불러오기
      String? storedKey = await _storage.read(key: _keyStorageKey);

      if (storedKey == null) {
        _key = enc.Key.fromSecureRandom(32);
        await _storage.write(key: _keyStorageKey, value: _key!.base64);
        print('✅ 새 암호화 키 생성 완료');
      } else {
        _key = enc.Key.fromBase64(storedKey);
        print('✅ 기존 암호화 키 불러옴');
      }

      // 2️⃣ IV 생성 (고정 IV — 실무에선 메시지별 랜덤 IV 권장)
      _iv = enc.IV.fromLength(16);

      // 3️⃣ Encrypter 초기화
      _encrypter = enc.Encrypter(enc.AES(_key!));

      _isInitialized = true;
      print('✅ 암호화 서비스 초기화 완료');
    } catch (e) {
      print('❌ 암호화 초기화 실패: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// 🔐 암호화
  String encrypt(String plainText) {
    if (!_isInitialized || _encrypter == null) {
      print('⚠️ 암호화 서비스가 초기화되지 않음 — 평문 반환');
      return plainText;
    }

    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _iv!);
      return encrypted.base64;
    } catch (e) {
      print('❌ 암호화 실패: $e');
      return plainText;
    }
  }

  /// 🔓 복호화
  String decrypt(String encryptedText) {
    if (!_isInitialized || _encrypter == null) {
      print('⚠️ 암호화 서비스가 초기화되지 않음 — 암호문 그대로 반환');
      return encryptedText;
    }

    try {
      final encrypted = enc.Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv!);
    } catch (e) {
      print('❌ 복호화 실패: $e');
      return encryptedText;
    }
  }

  /// 🗑️ 키 삭제 (로그아웃 시)
  Future<void> deleteKey() async {
    await _storage.delete(key: _keyStorageKey);
    _key = null;
    _iv = null;
    _encrypter = null;
    _isInitialized = false;
    print('🗑️ 암호화 키 삭제 완료');
  }
}