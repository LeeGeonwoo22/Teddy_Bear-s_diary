// like/common/encryption_service.dart
import 'package:encrypt/encrypt.dart' as enc;
import 'global.dart';

/// 🔐 EncryptionService
/// - AES-256 사용
/// - Key는 .env에서 고정 로드 (절대 런타임 생성 ❌)
/// - IV는 암호화할 때마다 새로 생성 (보안 필수)
class EncryptionService {
  // 🔒 싱글톤 (앱 전역에서 동일 키 사용)
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  late final enc.Key _key;
  late final enc.Encrypter _encrypter;
  enc.IV? _iv;
  bool _isInitialized = false;

  /// ✅ 명시적 초기화 (main 또는 injector에서 1회 호출)
  Future<void> init() async {
    if (_isInitialized) return;

    final keyString = Encryption_KEY;

    if (keyString == null) {
      throw Exception('❌ ENCRYPTION_KEY not found in .env');
    }

    if (keyString.length != 32) {
      throw Exception('❌ ENCRYPTION_KEY must be exactly 32 characters');
    }

    _key = enc.Key.fromUtf8(keyString);
    _iv = enc.IV.fromLength(16); // ⚠️ 고정 IV (의도적)
    _encrypter = enc.Encrypter(
      enc.AES(_key!, mode: enc.AESMode.cbc),
    );

    _isInitialized = true;
    print('✅ EncryptionService initialized successfully');
  }


  /// 🔐 암호화
  /// - IV는 메시지마다 새로 생성
  /// - cipher + iv 를 함께 저장해야 함
  Map<String, String> encrypt(String plainText) {
    if (!_isInitialized) {
      throw Exception('❌ EncryptionService not initialized');
    }

    // 1️⃣ 메시지별 랜덤 IV 생성 (보안 핵심)
    final iv = enc.IV.fromSecureRandom(16);

    // 2️⃣ 암호화
    final encrypted = _encrypter.encrypt(
      plainText,
      iv: iv,
    );

    // 3️⃣ Firestore / Hive 저장용 구조
    return {
      'cipher': encrypted.base64,
      'iv': iv.base64,
    };
  }

  /// 🔓 복호화
  /// - 반드시 "암호화 당시 사용한 IV"를 함께 전달해야 함
  String decrypt({
    required String cipherText,
    required String ivBase64,
  }) {
    if (!_isInitialized) {
      throw Exception('❌ EncryptionService not initialized');
    }

    try {
      final encrypted = enc.Encrypted.fromBase64(cipherText);
      final iv = enc.IV.fromBase64(ivBase64);

      return _encrypter.decrypt(
        encrypted,
        iv: iv,
      );
    } catch (e) {
      print('❌ Decryption failed: $e');
      // ❗ 실서비스에서는 여기서 fallback 처리 권장
      return cipherText;
    }
  }
}
