import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class User extends Equatable {
  final String uuid;
  final String? email;
  final String? name;
  final String? provider; // google, facebook, apple, guest
  final bool isGuest;

  const User({
    required this.uuid,
    this.email,
    this.name,
    this.provider,
    this.isGuest = false,
  });

  factory User.guest(String uuid) => User(
    uuid: const Uuid().v4(),
    provider: 'guest',
    isGuest: true,
  );

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
    );
  }

  @override
  List<Object?> get props => [uuid, email, name, provider, isGuest];
}
