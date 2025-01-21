import '../Model/User.dart';

abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}

class UserLoadingNextPage extends UserState {
  final List<User> existingUsers;

  UserLoadingNextPage({required this.existingUsers});
}

class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded({required this.users});
}

class UserError extends UserState {
  final String error;

  UserError({required this.error});
}
