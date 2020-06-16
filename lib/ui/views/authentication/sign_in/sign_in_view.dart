import 'package:flutter/material.dart';
import 'package:mind_dumps/ui/views/authentication/sign_in/widgets/buttons.dart';
import 'package:mind_dumps/ui/views/hero/title_hero.dart';
import 'package:provider/provider.dart';

import 'sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(context.read),
      builder: (_, child) {
        return Scaffold(
          appBar: AppBar(
            title: TitleHero(),
          ),
          body: SignInViewBody._(),
        );
      },
    );
  }
}

class SignInViewBody extends StatelessWidget {
  const SignInViewBody._({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((SignInViewModel viewModel) => viewModel.isLoading);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: isLoading ? _loadingIndicator() : _signInButtons(context),
          ),
        ],
      ),
    );
  }

  Center _loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column _signInButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Sign in with",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            google(context),
            facebook(context),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            " - OR - ",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Text(
          "Sign as Anonymous",
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Colors.indigo),
        ),
      ],
    );
  }
}
