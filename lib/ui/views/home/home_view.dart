import 'package:flutter/material.dart';
import 'package:mind_dumps/services/FirebaseAuthService.dart';
import 'package:mind_dumps/ui/views/hero/title_hero.dart';
import 'package:mind_dumps/ui/views/home/writer_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<FirebaseAuthService>().signOut();
            },
          ),
        ],
        title: TitleHero(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.fiber_new),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WriterView(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key key,
  }) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
