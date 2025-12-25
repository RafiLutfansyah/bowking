import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_google_id_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final GetGoogleIdToken getGoogleIdToken;

  AuthBloc({
    required this.authRepository,
    required this.getGoogleIdToken,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<GoogleSignInInitiated>(_onGoogleSignInInitiated);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isAuthenticated = await authRepository.isAuthenticated();

    if (isAuthenticated) {
      final result = await authRepository.getCurrentUser();
      result.fold(
        (failure) => emit(const Unauthenticated()),
        (user) => emit(Authenticated(user)),
      );
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onGoogleSignInInitiated(
    GoogleSignInInitiated event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final String? idToken = await getGoogleIdToken();

      if (idToken == null) {
        emit(const AuthError('Failed to get ID token from Google'));
        return;
      }

      final result = await authRepository.googleSignIn(idToken);

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError('Sign-in error: ${e.toString()}'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.googleSignIn(event.idToken);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }
}
