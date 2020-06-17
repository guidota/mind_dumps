import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/models/User.dart';

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

class GoogleSignInEvent extends AuthEvent {}

class AuthStart extends AuthEvent {}

class AuthFailed extends AuthEvent {}

class AuthOK extends AuthEvent {
  final User user;

  AuthOK(this.user);
}

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class Authenticating extends AuthState {}

class NoAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({this.repository});

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
    } else if (event is GoogleSignInEvent) {
      yield* mapGoogleSignInToState();
    } else if (event is StartApp) {
      yield* mapAppStartToState();
    }
  }

  Stream<AuthState> mapAppStartToState() async* {
    try {
      final isAuthenticated = await repository.isAuthenticated();
      if (isAuthenticated) {
        yield Authenticated(await repository.getUser());
      } else {
        yield NoAuthenticated();
      }
    } catch (_) {
      yield NoAuthenticated();
    }
  }

  Stream<AuthState> mapGoogleSignInToState() async* {
    repository
        .signInWithGoogle()
        .then((value) => add(AuthOK(value)))
        .catchError(
      (onError) {
        print(onError);
        add(AuthFailed());
      },
    );
    yield Authenticating();
  }
}
