import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';

Widget google(BuildContext context) => button(
      Image(
        image: AssetImage(
          "graphics/google-logo.png",
          package: "flutter_auth_buttons",
        ),
        height: 18.0,
        width: 18.0,
      ),
      () => {
        context.bloc<AuthBloc>().add(AuthStart()),
        context
            .repository<AuthRepository>()
            .signInWithGoogle()
            .then((value) => value)
            .catchError(
              (error) => {
                print(error),
                Scaffold.of(context).showSnackBar(loginFailed())
              },
            ),
      },
      Colors.white,
      Colors.indigo,
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

SnackBar loginFailed() => SnackBar(
      content: Text("Failed to Login!"),
      backgroundColor: Colors.grey,
    );

Widget facebook(BuildContext context) => button(
      Image(
        image: AssetImage(
          "graphics/flogo-HexRBG-Wht-100.png",
          package: "flutter_auth_buttons",
        ),
        height: 18.0,
        width: 18.0,
      ),
      () => {Scaffold.of(context).showSnackBar(loginFailed())},
      Colors.indigo,
      Colors.white,
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

Widget button(Image image, VoidCallback onPressed, Color buttonColor,
    Color splashColor, ShapeBorder shape) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: RaisedButton(
      onPressed: onPressed,
      color: buttonColor,
      splashColor: splashColor,
      shape: shape,
      child: Container(
        padding: const EdgeInsets.all(1.0),
        height: 38.0,
        width: 38.0,
        // matches above
        child: image,
      ),
    ),
  );
}
