part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LoadUserData extends UserEvent {
  final String userId;

  const LoadUserData(this.userId);

  @override
  List<Object> get props => [userId];
}