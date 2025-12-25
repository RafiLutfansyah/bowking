import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class GoogleSignInInitiated extends AuthEvent {
  const GoogleSignInInitiated();
}

class GoogleSignInRequested extends AuthEvent {
  final String idToken;

  const GoogleSignInRequested(this.idToken);

  @override
  List<Object> get props => [idToken];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
