import 'package:customer_booking/core/domain/entities/user_profile.dart';
import 'package:equatable/equatable.dart';

enum UserProfileStatus { initial, loading, loaded, error }

class UserProfileState extends Equatable {
  final UserProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  int get credits => profile?.credits ?? 0;

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
