abstract class UserEvent {}

class LoadUsersEvent extends UserEvent {
  final int page;

  LoadUsersEvent({required this.page});
}
