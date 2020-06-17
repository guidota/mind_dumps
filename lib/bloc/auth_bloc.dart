import 'package:mind_dumps/models/User.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthRepository {
  Stream<User> user();
  Future<User> getUser();
  Future<bool> isAuthenticated();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<void> signOut();
}

abstract class AuthEvent {}

class StartApp extends AuthEvent {}

class AuthStart extends AuthEvent {}

class AuthFailed extends AuthEvent {}

class AuthOK extends AuthEvent {
  final User user;

  AuthOK(this.user);
}

abstract class AuthState {}

class Authenticating extends AuthState {}

class NoAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository _repository;

  AuthBloc(this._repository) {
    _repository.user().listen((event) {
      if (event != null) {
        add(AuthOK(event));
      } else {
        add(AuthFailed());
      }
    });
  }

  @override
  AuthState get initialState => NoAuthenticated();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthFailed) {
      yield NoAuthenticated();
    } else if (event is AuthOK) {
      yield Authenticated(event.user);
    } else if (event is AuthStart) {
      yield Authenticating();
    } else if (event is StartApp) {
      yield* mapAppStartToState();
    }
  }

  Stream<AuthState> mapAppStartToState() async* {
    try {
      final isAuthenticated = await _repository.isAuthenticated();
      if (isAuthenticated) {
        yield Authenticated(await _repository.getUser());
      } else {
        yield NoAuthenticated();
      }
    } catch (_) {
      yield NoAuthenticated();
    }
  }
}
