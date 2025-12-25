import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object?> get props => [];
}

class CurrentUserInitial extends CurrentUserState {
  const CurrentUserInitial();
}

class CurrentUserAuthenticated extends CurrentUserState {
  final User user;

  const CurrentUserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class CurrentUserUnauthenticated extends CurrentUserState {
  const CurrentUserUnauthenticated();
}
