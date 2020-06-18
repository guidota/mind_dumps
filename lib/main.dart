import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';
import 'package:mind_dumps/repository/auth_repository.dart';
import 'package:mind_dumps/ui/views/home/home_view.dart';
import 'package:provider/provider.dart';

import 'ui/views/authentication/sign_in/sign_in_view.dart';

void main() => runApp(
      RepositoryProvider<AuthRepository>(
        create: (_) => FirebaseAuthRepository(),
        child: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(StartApp()),
          child: ChangeNotifierProvider<ThemeStateNotifier>(
            create: (_) => ThemeStateNotifier(),
            child: MyApp(),
          ),
        ),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor _color = Colors.lightBlue;
    return Consumer<ThemeStateNotifier>(
      builder: (context, value, child) => MaterialApp(
        title: 'Mind Dumps',
        debugShowCheckedModeBanner: false,
        themeMode: value.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.dark(
            primary: Colors.grey[800],
            primaryVariant: Colors.grey[900],
            secondary: _color[800],
            secondaryVariant: _color[900],
            background: Colors.grey[900],
            surface: Colors.grey[900],
            error: Colors.red,
            onPrimary: Colors.grey[100],
            onSecondary: Colors.grey[100],
            onSurface: Colors.grey[900],
            onError: Colors.grey[50],
          ),
        ).copyWith(
          accentColor: _color[500],
          toggleableActiveColor: _color[500],
          textSelectionHandleColor: _color[500],
          textSelectionColor: _color[500],
        ),
        theme: ThemeData.light(),
//        darkTheme: ThemeData(
//          accentColor: Colors.amber[200],
//          colorScheme: ColorScheme.dark(
//            primary: Colors.grey[800],
//            primaryVariant: Colors.grey[900],
//            secondary: Colors.deepPurple[800],
//            secondaryVariant: Colors.deepPurple[900],
//            background: Colors.grey[500],
//            surface: Colors.grey[500],
//            error: Colors.red,
//            onPrimary: Colors.grey[100],
//            onSecondary: Colors.grey[100],
//            onSurface: Colors.grey[900],
//            onError: Colors.grey[50],
//          ),
//        ),
        home: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            return false;
          },
          listener: (context, state) {
            // do stuff here based on BlocA's state
          },
          buildWhen: (previous, current) {
            return true; // review
          },
          builder: (context, state) {
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
          },
        ),
      ),
    );
  }
}

class ThemeStateNotifier extends ChangeNotifier {
  bool isDarkMode = ThemeMode.system == ThemeMode.dark;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
