import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> googleSignIn(String idToken);
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<bool> isAuthenticated();
  Future<String?> getGoogleIdToken();
}
