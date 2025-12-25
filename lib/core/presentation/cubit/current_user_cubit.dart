import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(const CurrentUserInitial());

  void setUser(User user) {
    emit(CurrentUserAuthenticated(user));
  }

  void clearUser() {
    emit(const CurrentUserUnauthenticated());
  }

  User? get currentUser {
    final state = this.state;
    if (state is CurrentUserAuthenticated) {
      return state.user;
    }
    return null;
  }
}
