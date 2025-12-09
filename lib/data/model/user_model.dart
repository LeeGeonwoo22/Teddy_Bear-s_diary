import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? uid;
  final String? name;
  final String? email;

  const UserModel({ this.uid,  this.name,  this.email});

  List<Object?> get props => [
    uid,
    name,
    email,
  ];
}