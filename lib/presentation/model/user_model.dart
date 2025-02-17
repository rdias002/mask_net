import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String userId;
  final String username;
  final String email;

  const UserProfile(
      {required this.userId, required this.username, required this.email});

  @override
  List<Object?> get props => [userId, username, email];

  UserProfile copyWith({
    String? userId,
    String? username,
    String? email,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
