import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';
import 'package:mind_dumps/repository/auth_repository.dart';
import 'package:mind_dumps/ui/views/hero/mind_dump_animation.dart';
import 'package:mind_dumps/ui/views/home/home_view.dart';

import 'ui/views/authentication/sign_in/sign_in_view.dart';

void main() => runApp(
      RepositoryProvider<AuthRepository>(
        create: (_) => FirebaseAuthRepository(),
        child: BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(RepositoryProvider.of<AuthRepository>(context))
                ..add(StartApp()),
          child: MyApp(),
        ),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Dumps',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        accentColor: Colors.amber[200],
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[800],
          primaryVariant: Colors.grey[900],
          secondary: Colors.deepPurple[800],
          secondaryVariant: Colors.deepPurple[900],
          background: Colors.grey[500],
          surface: Colors.grey[500],
          error: Colors.red,
          onPrimary: Colors.grey[100],
          onSecondary: Colors.grey[100],
          onSurface: Colors.grey[900],
          onError: Colors.grey[50],
        ),
      ),
      home: BlocConsumer<AuthBloc, AuthState>(listenWhen: (previous, current) {
        return false;
      }, listener: (context, state) {
        // do stuff here based on BlocA's state
      }, buildWhen: (previous, current) {
        return true; // review
      }, builder: (context, state) {
        if (state is Authenticating) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Authenticated) {
          return const HomeView();
        }
        return const SignInView();
      }),
    );
  }
}
