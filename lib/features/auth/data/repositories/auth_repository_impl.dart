import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_auth_datasource.dart';
import '../datasources/google_signin_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource remoteDataSource;
  final GoogleSignInDataSource googleSignInDataSource;
  final NetworkInfo networkInfo;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.googleSignInDataSource,
    required this.networkInfo,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, User>> googleSignIn(String idToken) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // Get Google user data
      final googleUser = await googleSignInDataSource.signIn();
      if (googleUser == null) {
        return const Left(AuthFailure('Google sign-in cancelled'));
      }

      // Send user data to backend
      final userData = {
        'google_id': googleUser.googleId,
        'email': googleUser.email,
        'name': googleUser.name,
        'avatar_url': googleUser.avatarUrl,
      };
      
      final user = await remoteDataSource.googleSignIn(userData);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.logout();
      await googleSignInDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await remoteDataSource.isAuthenticated();
  }

  @override
  Future<String?> getGoogleIdToken() async {
    try {
      final googleUser = await googleSignInDataSource.signIn();
      if (googleUser == null) return null;
      
      // Return google_id instead of id_token
      return googleUser.googleId;
    } catch (e) {
      return null;
    }
  }
}
