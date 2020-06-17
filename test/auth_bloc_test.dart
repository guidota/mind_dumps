import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';
import 'package:mind_dumps/models/User.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  AuthBloc authBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    when(authRepository.user()).thenAnswer((realInvocation) => Stream.empty());
    authBloc = AuthBloc(repository: authRepository);
  });

  tearDown(() {
    authBloc?.close();
  });

  test('initial state is correct', () {
    expect(authBloc.initialState, NoAuthenticated());
  });

  group('Auth bloc test when app starts', () {
    final User user = User(
        uid: '123', displayName: 'guidota', email: 'a@a.com', photoUrl: '');
    blocTest(
      'emits [Authenticating, Authenticated] when StartApp is added',
      build: () {
        when(authRepository.isAuthenticated()).thenAnswer(
            (_) => Future.delayed(Duration(milliseconds: 10), () => true));
        when(authRepository.getUser()).thenAnswer(
            (_) => Future.delayed(Duration(milliseconds: 10), () => user));
        return Future.value(authBloc);
      },
      act: (bloc) => bloc.add(StartApp()),
      expect: [Authenticated(user)],
    );
  });

  group('Auth bloc test when user sign in with Google', () {
    final User user = User(
        uid: '123', displayName: 'guidota', email: 'a@a.com', photoUrl: '');
    blocTest(
      'emits [Authenticating, Authenticated] when GoogleSignInEvent is added',
      wait: Duration(milliseconds: 150),
      build: () {
        when(authRepository.signInWithGoogle()).thenAnswer(
            (_) => Future.delayed(Duration(milliseconds: 100), () => user));
        return Future.delayed(Duration(milliseconds: 10), () => authBloc);
      },
      act: (bloc) => bloc.add(GoogleSignInEvent()),
      expect: [Authenticating(), Authenticated(user)],
    );
  });

  test('close does not emit new states', () {
    expectLater(
      authBloc,
      emitsInOrder([NoAuthenticated(), emitsDone]),
    );
    authBloc.close();
  });
}
