# Comprehensive Unit Testing Strategy - Bowking Frontend

**Date:** 2025-12-26  
**Project:** Bowking Frontend (Flutter)  
**Scope:** All layers across all features including core

---

## 1. Testing Philosophy & Architecture

### Testing Philosophy
Project ini mengikuti **Test Pyramid** dengan fokus pada unit tests sebagai foundation:
- **70% Unit Tests** - Isolated testing untuk semua business logic
- **20% Widget Tests** - Component behavior & UI logic
- **10% Integration Tests** - End-to-end flow (future scope)

### Test Structure Overview
Menggunakan **Mirror Structure** yang merefleksikan struktur `lib/`:

```
test/
├── core/
│   ├── domain/
│   │   ├── entities/
│   │   └── payment/
│   ├── presentation/
│   │   ├── cubit/
│   │   └── payment/
│   ├── network/
│   ├── storage/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       └── bloc/
│   ├── booking/
│   ├── rewards/
│   └── wallet/
└── helpers/
    ├── test_helpers.dart (mock factories)
    ├── fixture_reader.dart
    └── fixtures/ (test data JSON files)
```

### Mocking Strategy
- **Mocktail** untuk semua mocks (manual mock classes)
- **bloc_test** untuk testing BLoCs dengan state verification
- **Fixture files** untuk consistent test data across tests
- **Helper functions** untuk setup yang reusable

### Test Coverage Target
- **Entities**: 100% (simple data classes, easy to test)
- **UseCases**: 100% (critical business logic)
- **Repositories**: 100% (data flow & error handling)
- **BLoCs**: 100% (state management & user interactions)
- **DataSources**: 90% (API & storage interactions)
- **Models**: 90% (JSON serialization)
- **Widgets**: 80% (UI components)
- **Overall**: ≥85%

---

## 2. Layer-by-Layer Testing Strategy

### 2.1 Entity Testing (Domain Layer)

**What to test:**
- Property equality (Equatable)
- Immutability
- Edge cases (null values, empty strings)

**Example Pattern:**
```dart
// test/core/domain/entities/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bowking/core/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('should support value equality', () {
      final user1 = User(id: '1', name: 'John', email: 'john@test.com');
      final user2 = User(id: '1', name: 'John', email: 'john@test.com');
      expect(user1, user2);
    });

    test('should have correct props for equality', () {
      final user = User(id: '1', name: 'John', email: 'john@test.com');
      expect(user.props, ['1', 'John', 'john@test.com']);
    });
  });
}
```

### 2.2 UseCase Testing (Domain Layer)

**What to test:**
- Successful execution
- Error handling from repository
- Parameter passing

**Example Pattern:**
```dart
// test/features/auth/domain/usecases/sign_in_with_google_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:bowking/features/auth/domain/usecases/sign_in_with_google.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignInWithGoogle usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignInWithGoogle(mockRepository);
  });

  test('should return User on success', () async {
    // Arrange
    final tUser = TestHelpers.createTestUser();
    when(() => mockRepository.googleSignIn(any()))
        .thenAnswer((_) async => Right(tUser));

    // Act
    final result = await usecase('test-token');

    // Assert
    expect(result, Right(tUser));
    verify(() => mockRepository.googleSignIn('test-token')).called(1);
  });

  test('should return Failure on error', () async {
    // Arrange
    const tFailure = AuthFailure('Error');
    when(() => mockRepository.googleSignIn(any()))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await usecase('test-token');

    // Assert
    expect(result, const Left(tFailure));
  });
}
```

### 2.3 Model Testing (Data Layer)

**What to test:**
- fromJson() deserialization
- toJson() serialization
- Edge cases (missing fields, null values)
- Inheritance from entity

**Example Pattern:**
```dart
// test/features/auth/data/models/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bowking/features/auth/data/models/user_model.dart';
import 'package:bowking/core/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    final tUserModel = UserModel(
      id: '1',
      name: 'John',
      email: 'john@test.com',
    );

    test('should be a subclass of User entity', () {
      expect(tUserModel, isA<User>());
    });

    group('fromJson', () {
      test('should return valid model from JSON', () {
        final json = {
          'id': '1',
          'name': 'John',
          'email': 'john@test.com',
        };
        final result = UserModel.fromJson(json);
        expect(result, tUserModel);
      });

      test('should handle null optional fields', () {
        final json = {
          'id': '1',
          'name': 'John',
          'email': 'john@test.com',
        };
        expect(() => UserModel.fromJson(json), returnsNormally);
      });
    });

    group('toJson', () {
      test('should return JSON map with proper data', () {
        final result = tUserModel.toJson();
        expect(result, {
          'id': '1',
          'name': 'John',
          'email': 'john@test.com',
        });
      });
    });
  });
}
```

### 2.4 Repository Testing (Data Layer)

**What to test:**
- Network connectivity check
- Successful data flow from datasource
- Error handling (network errors, server errors)
- Either<Failure, Success> return types

**Example Pattern:**
```dart
// test/features/auth/data/repositories/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:bowking/features/auth/data/repositories/auth_repository_impl.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late MockRemoteAuthDataSource mockRemoteDataSource;
  late MockGoogleSignInDataSource mockGoogleSignInDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteAuthDataSource();
    mockGoogleSignInDataSource = MockGoogleSignInDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      googleSignInDataSource: mockGoogleSignInDataSource,
      networkInfo: mockNetworkInfo,
      tokenStorage: mockTokenStorage,
    );
  });

  group('googleSignIn', () {
    final tUserModel = TestHelpers.createTestUser();
    const tIdToken = 'test-token';

    test('should check network connectivity', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.googleSignIn(any()))
          .thenAnswer((_) async => tUserModel);

      await repository.googleSignIn(tIdToken);

      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    test('should return User when network is connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.googleSignIn(tIdToken))
          .thenAnswer((_) async => tUserModel);

      final result = await repository.googleSignIn(tIdToken);

      expect(result, Right(tUserModel));
      verify(() => mockRemoteDataSource.googleSignIn(tIdToken)).called(1);
    });

    test('should return NetworkFailure when disconnected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.googleSignIn(tIdToken);

      expect(result, const Left(NetworkFailure('No internet connection')));
      verifyNever(() => mockRemoteDataSource.googleSignIn(any()));
    });

    test('should return AuthFailure on exception', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.googleSignIn(tIdToken))
          .thenThrow(Exception('Auth error'));

      final result = await repository.googleSignIn(tIdToken);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
```

### 2.5 DataSource Testing (Data Layer)

**What to test:**
- API calls with correct endpoints
- Request headers & parameters
- Response parsing
- Exception handling (DioException)

**Example Pattern:**
```dart
// test/features/auth/data/datasources/remote_auth_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:bowking/features/auth/data/datasources/remote_auth_datasource.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late MockDio mockDio;
  late RemoteAuthDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = RemoteAuthDataSourceImpl(mockDio);
  });

  group('googleSignIn', () {
    final tUserJson = {
      'id': '1',
      'name': 'John',
      'email': 'john@test.com',
    };
    const tIdToken = 'test-token';

    test('should perform POST request to correct endpoint', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: tUserJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await dataSource.googleSignIn(tIdToken);

      verify(() => mockDio.post(
            '/auth/google',
            data: {'idToken': tIdToken},
          )).called(1);
    });

    test('should return UserModel when response is 200', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: tUserJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataSource.googleSignIn(tIdToken);

      expect(result, isA<UserModel>());
      expect(result.id, '1');
    });

    test('should throw ServerException on 4xx/5xx codes', () async {
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: ''),
            ),
          ));

      expect(
        () => dataSource.googleSignIn(tIdToken),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
```

### 2.6 BLoC Testing (Presentation Layer)

**What to test:**
- Initial state
- State transitions on events
- Multiple scenarios (success, loading, error)
- Dependency interactions

**Example Pattern:**
```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:bowking/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockGetGoogleIdToken mockGetGoogleIdToken;
  late AuthBloc bloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockGetGoogleIdToken = MockGetGoogleIdToken();
    bloc = AuthBloc(
      authRepository: mockAuthRepository,
      getGoogleIdToken: mockGetGoogleIdToken,
    );
  });

  test('initial state should be AuthInitial', () {
    expect(bloc.state, const AuthInitial());
  });

  group('GoogleSignInInitiated', () {
    final tUser = TestHelpers.createTestUser();
    const tIdToken = 'test-token';

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, Authenticated] on success',
      build: () {
        when(() => mockGetGoogleIdToken()).thenAnswer((_) async => tIdToken);
        when(() => mockAuthRepository.googleSignIn(tIdToken))
            .thenAnswer((_) async => Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const GoogleSignInInitiated()),
      expect: () => [
        const AuthLoading(),
        Authenticated(tUser),
      ],
      verify: (_) {
        verify(() => mockGetGoogleIdToken()).called(1);
        verify(() => mockAuthRepository.googleSignIn(tIdToken)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when token is null',
      build: () {
        when(() => mockGetGoogleIdToken()).thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(const GoogleSignInInitiated()),
      expect: () => [
        const AuthLoading(),
        const AuthError('Failed to get ID token from Google'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockGetGoogleIdToken()).thenAnswer((_) async => tIdToken);
        when(() => mockAuthRepository.googleSignIn(tIdToken))
            .thenAnswer((_) async => const Left(AuthFailure('Auth failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(const GoogleSignInInitiated()),
      expect: () => [
        const AuthLoading(),
        const AuthError('Auth failed'),
      ],
    );
  });
}
```

### 2.7 Widget Testing (Presentation Layer)

**What to test:**
- Widget renders correctly
- User interactions (tap, input)
- State changes trigger UI updates
- Loading, error, and success states

**Example Pattern:**
```dart
// test/core/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bowking/core/widgets/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('should render label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var wasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () => wasCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(wasCalled, true);
    });

    testWidgets('should show loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should not call onPressed when disabled', (tester) async {
      var wasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () => wasCalled = true,
              isEnabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(wasCalled, false);
    });
  });
}
```

---

## 3. Test Helpers & Fixtures

### 3.1 Test Helpers Structure

```dart
// test/helpers/test_helpers.dart
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:bowking/core/network/network_info.dart';
import 'package:bowking/core/storage/token_storage.dart';
import 'package:bowking/features/auth/domain/repositories/auth_repository.dart';
// ... import all required classes

// Core Mocks
class MockDio extends Mock implements Dio {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockTokenStorage extends Mock implements TokenStorage {}

// Auth Mocks
class MockAuthRepository extends Mock implements AuthRepository {}
class MockRemoteAuthDataSource extends Mock implements RemoteAuthDataSource {}
class MockGoogleSignInDataSource extends Mock implements GoogleSignInDataSource {}
class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}
class MockGetGoogleIdToken extends Mock implements GetGoogleIdToken {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}

// Wallet Mocks
class MockWalletRepository extends Mock implements WalletRepository {}
class MockGetWallet extends Mock implements GetWallet {}
class MockGetTransactionHistory extends Mock implements GetTransactionHistory {}

// Booking Mocks
class MockBookingRepository extends Mock implements BookingRepository {}
class MockGetAvailableServices extends Mock implements GetAvailableServices {}
class MockCreateBooking extends Mock implements CreateBooking {}

// Rewards Mocks
class MockRewardsRepository extends Mock implements RewardsRepository {}
class MockGetAvailableOffers extends Mock implements GetAvailableOffers {}
class MockGetClaimedOffers extends Mock implements GetClaimedOffers {}
class MockClaimOffer extends Mock implements ClaimOffer {}

// Helper Functions
class TestHelpers {
  static User createTestUser({
    String id = '1',
    String name = 'Test User',
    String email = 'test@example.com',
  }) {
    return User(id: id, name: name, email: email);
  }

  static Wallet createTestWallet({
    String userId = '1',
    double balanceRM = 100.0,
    int balanceTokens = 500,
  }) {
    return Wallet(
      userId: userId,
      balanceRM: balanceRM,
      balanceTokens: balanceTokens,
    );
  }

  static Offer createTestOffer({
    String id = '1',
    String title = 'Test Offer',
    int requiredTokens = 100,
  }) {
    return Offer(
      id: id,
      title: title,
      requiredTokens: requiredTokens,
      description: 'Test description',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  static Service createTestService({
    String id = '1',
    String name = 'Test Service',
    double priceRM = 50.0,
  }) {
    return Service(
      id: id,
      name: name,
      priceRM: priceRM,
      description: 'Test service description',
    );
  }

  static WalletTransaction createTestTransaction({
    String id = '1',
    double amountRM = 50.0,
    String type = 'debit',
  }) {
    return WalletTransaction(
      id: id,
      amountRM: amountRM,
      type: type,
      description: 'Test transaction',
      createdAt: DateTime.now(),
    );
  }
}
```

### 3.2 Fixture Files

**Directory structure:**
```
test/helpers/fixtures/
├── user.json
├── wallet.json
├── transaction.json
├── offer.json
├── service.json
└── booking.json
```

**Fixture Reader:**
```dart
// test/helpers/fixture_reader.dart
import 'dart:io';

String fixture(String name) {
  return File('test/helpers/fixtures/$name').readAsStringSync();
}
```

**Example Fixture (user.json):**
```json
{
  "id": "1",
  "name": "Test User",
  "email": "test@example.com",
  "createdAt": "2025-01-01T00:00:00.000Z"
}
```

**Usage in tests:**
```dart
import 'dart:convert';
import '../../../helpers/fixture_reader.dart';

final jsonString = fixture('user.json');
final json = jsonDecode(jsonString);
final user = UserModel.fromJson(json);
```

---

## 4. Test Organization & Execution

### 4.1 Test File Naming Convention

**Strict naming pattern:**
- Unit tests: `{filename}_test.dart`
- Widget tests: `{widget_name}_test.dart`
- BLoC tests: `{bloc_name}_test.dart`

**Examples:**
```
lib/features/auth/domain/usecases/sign_in_with_google.dart
→ test/features/auth/domain/usecases/sign_in_with_google_test.dart

lib/core/widgets/custom_button.dart
→ test/core/widgets/custom_button_test.dart
```

### 4.2 Test Execution Commands

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/domain/usecases/sign_in_with_google_test.dart

# Run tests for specific feature
flutter test test/features/auth/

# Run with verbose output
flutter test --reporter expanded

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 4.3 Complete Test Coverage Breakdown

**Per-Feature Test Count Estimates:**

**Auth Feature (~18 test files):**
- domain/usecases/sign_in_with_google_test.dart - 3 tests
- domain/usecases/get_current_user_test.dart - 3 tests
- domain/usecases/get_google_id_token_test.dart - 3 tests
- data/models/user_model_test.dart - 5 tests
- data/datasources/remote_auth_datasource_test.dart - 8 tests
- data/datasources/google_signin_datasource_test.dart - 6 tests
- data/repositories/auth_repository_impl_test.dart - 15 tests
- presentation/bloc/auth_bloc_test.dart - 12 tests

**Wallet Feature (~20 test files):**
- domain/entities/wallet_test.dart - 3 tests
- domain/entities/wallet_transaction_test.dart - 3 tests
- domain/usecases/get_wallet_test.dart - 3 tests
- domain/usecases/get_transaction_history_test.dart - 3 tests
- data/models/wallet_model_test.dart - 5 tests
- data/models/wallet_transaction_model_test.dart - 5 tests
- data/adapters/wallet_payment_adapter_test.dart - 6 tests
- data/datasources/remote_wallet_datasource_test.dart - 8 tests
- data/repositories/wallet_repository_impl_test.dart - 12 tests
- presentation/bloc/wallet_bloc_test.dart - 15 tests

**Booking Feature (~18 test files):**
- domain/entities/booking_test.dart - 3 tests
- domain/entities/service_test.dart - 3 tests
- domain/usecases/get_available_services_test.dart - 3 tests
- domain/usecases/create_booking_test.dart - 4 tests
- data/models/booking_model_test.dart - 5 tests
- data/models/service_model_test.dart - 5 tests
- data/datasources/remote_booking_datasource_test.dart - 8 tests
- data/repositories/booking_repository_impl_test.dart - 12 tests
- presentation/bloc/booking_bloc_test.dart - 12 tests

**Rewards Feature (~22 test files):**
- domain/entities/offer_test.dart - 3 tests
- domain/usecases/get_available_offers_test.dart - 3 tests
- domain/usecases/get_claimed_offers_test.dart - 3 tests
- domain/usecases/claim_offer_test.dart - 4 tests
- data/models/offer_model_test.dart - 5 tests
- data/datasources/remote_rewards_datasource_test.dart - 10 tests
- data/repositories/rewards_repository_impl_test.dart - 15 tests
- presentation/bloc/rewards_bloc_test.dart - 15 tests
- presentation/widgets/countdown_timer_test.dart - 8 tests

**Core (~25 test files):**
- domain/entities/user_test.dart - 3 tests
- domain/payment/payment_method_test.dart - 3 tests
- domain/payment/payment_result_test.dart - 3 tests
- domain/payment/user_balance_test.dart - 3 tests
- network/api_client_test.dart - 5 tests
- network/network_info_test.dart - 4 tests
- network/auth_interceptor_test.dart - 8 tests
- storage/token_storage_test.dart - 6 tests
- presentation/cubit/current_user_cubit_test.dart - 10 tests
- presentation/payment/payment_bloc_test.dart - 12 tests
- widgets/custom_button_test.dart - 12 tests
- widgets/custom_text_field_test.dart - 10 tests
- widgets/custom_card_test.dart - 8 tests
- widgets/error_widget_test.dart - 6 tests

**Total: ~103 test files, ~400+ individual tests**

---

## 5. Implementation Workflow

### 5.1 Development Order

1. **Setup Phase**
   - Create test/helpers/test_helpers.dart with all mock classes
   - Create test/helpers/fixture_reader.dart
   - Create fixture JSON files in test/helpers/fixtures/

2. **Core Layer** (foundation for features)
   - Core domain entities
   - Core network & storage
   - Core presentation (cubits/blocs)
   - Core widgets

3. **Features - Bottom-up per feature:**
   - Domain entities
   - Domain usecases
   - Data models
   - Data datasources
   - Data repositories
   - Presentation BLoCs
   - Presentation widgets

4. **Verification Phase**
   - Run all tests
   - Generate coverage report
   - Fix failing tests
   - Achieve target coverage

### 5.2 Quality Gates

**Before marking complete:**
- ✅ All tests pass (flutter test exits with code 0)
- ✅ No test warnings or deprecations
- ✅ Coverage meets targets:
  - Overall: ≥85%
  - Domain layer: 100%
  - Data layer: ≥90%
  - Presentation layer: ≥85%
- ✅ Test execution time: <30 seconds total
- ✅ All mocks properly verified
- ✅ No flaky tests (run 3x to verify stability)

**Coverage Exemptions:**
- Generated files (*.g.dart, *.freezed.dart)
- main.dart and injection_container.dart
- UI pages (tested via widget tests)
- Theme files (constants only)

### 5.3 Maintenance Guidelines

**When adding new features:**
1. Write entity tests first
2. Write usecase tests before implementation
3. Write repository tests alongside implementation
4. Write BLoC tests before hooking up UI
5. Minimum 80% coverage for new code

**When fixing bugs:**
1. Write failing test that reproduces bug
2. Fix the code to make test pass
3. Verify related tests still pass

---

## 6. Summary

Comprehensive unit testing strategy untuk Bowking frontend:

✅ **Mirror structure** - test directory matching lib/  
✅ **Mocktail** - manual mocks, type-safe & readable  
✅ **bloc_test** - BLoC state verification  
✅ **400+ tests** across 103 test files  
✅ **85%+ coverage** dengan focus pada business logic  
✅ **Test helpers** - reusable mocks & fixtures  
✅ **Layer-by-layer** - entities → usecases → repositories → BLoCs  
✅ **Widget tests** - core UI components  
✅ **CI/CD ready** - coverage reporting

**Tools & Dependencies:**
- flutter_test (SDK)
- bloc_test: ^9.1.7 (already in pubspec.yaml)
- mocktail: ^1.0.4 (already in pubspec.yaml)

**Expected Outcomes:**
- High confidence in business logic correctness
- Early bug detection through comprehensive testing
- Easier refactoring with test safety net
- Documentation through test examples
- CI/CD pipeline integration ready
