import '../repositories/auth_repository.dart';

class GetGoogleIdToken {
  final AuthRepository repository;

  GetGoogleIdToken(this.repository);

  Future<String?> call() async {
    return await repository.getGoogleIdToken();
  }
}
