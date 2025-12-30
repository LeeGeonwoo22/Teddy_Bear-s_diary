
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uuid;
  final String? email;
  final String? name;
  final String? provider;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime? upgradedAt; // 비회원 → 소셜 전환 날짜

  const User({
    required this.uuid,
    this.email,
    this.name,
    this.provider,
    this.isGuest = false,
    required this.createdAt,
    this.upgradedAt,
  });

  /// 비회원 생성 팩토리
  factory User.guest({String? uuid}) => User(
    uuid: uuid ?? '',
    provider: 'guest',
    isGuest: true,
    createdAt: DateTime.now(),
  );

  /// 소셜 로그인 사용자 생성 팩토리
  factory User.social({
    required String uuid,
    required String name,
    required String email,
    required String provider,
  }) {
    return User(
      uuid: uuid,
      name: name,
      email: email,
      provider: provider,
      isGuest: false,
      createdAt: DateTime.now(),
    );
  }

  /// Firestore에서 가져올 때
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      provider: json['provider'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      upgradedAt: json['upgradedAt'] != null
          ? (json['upgradedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Firestore에 저장할 때
  Map<String, dynamic> toJson() {
    final map = {
      'uuid': uuid,
      'email': email,
      'name': name,
      'provider': provider,
      'isGuest': isGuest,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    // upgradedAt이 있을 때만 추가
    if (upgradedAt != null) {
      map['upgradedAt'] = Timestamp.fromDate(upgradedAt!);
    }

    return map;
  }

  /// copyWith 메서드
  User copyWith({
    String? uuid,
    String? email,
    String? name,
    String? provider,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? upgradedAt,
  }) {
    return User(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      upgradedAt: upgradedAt ?? this.upgradedAt,
    );
  }

  @override
  List<Object?> get props => [uuid, email, name, provider, isGuest, createdAt, upgradedAt];
}