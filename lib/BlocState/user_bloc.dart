import 'package:flutter_bloc/flutter_bloc.dart';
import '../Model/User.dart';
import '../Service/ApiService.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;
  int currentPage = 1;
  List<User> users = [];

  UserBloc({required this.apiService}) : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsersEvent);
  }

  // Load the data from the API
  Future<void> _onLoadUsersEvent(LoadUsersEvent event, Emitter<UserState> emit) async {
    // Avoid loading more when already loading
    if (state is UserLoading || state is UserLoadingNextPage) return;

    if (event.page == 1) {
      emit(UserLoading());
    } else {
      emit(UserLoadingNextPage(existingUsers: users));
    }

    try {
      List<User> newUsers = await apiService.fetchUsers(event.page);
      if (event.page == 1) {
        users = newUsers;
      } else {
        users.addAll(newUsers);
      }
      emit(UserLoaded(users: users));
      currentPage = event.page;
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }

  void loadNextPage() {
    currentPage++;
    add(LoadUsersEvent(page: currentPage));
  }
}

