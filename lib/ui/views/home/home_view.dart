import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';
import 'package:mind_dumps/bloc/dumps_bloc.dart';
import 'package:mind_dumps/models/dump.dart';
import 'package:mind_dumps/repository/dump_repository.dart';
import 'package:mind_dumps/ui/views/hero/title_hero.dart';
import 'package:mind_dumps/ui/views/home/writer_view.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import 'widgets/dumps.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userState = context.bloc<AuthBloc>().state as Authenticated;
    return RepositoryProvider<DumpRepository>(
      create: (context) => FirestoreDumpRepository(userState.user)..refresh(),
      child: BlocProvider<DumpsBloc>(
        create: (context) => DumpsBloc(context.repository<DumpRepository>()),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  context.repository<AuthRepository>().signOut();
                },
              ),
              Switch(
                value: Provider.of<ThemeStateNotifier>(context).isDarkMode,
                onChanged: (boolVal) {
                  Provider.of<ThemeStateNotifier>(context, listen: false)
                      .updateTheme(boolVal);
                },
              )
            ],
            title: TitleHero(),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.note_add),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriterView(
                  dump: MindDump.empty(),
                ),
              ),
            ),
          ),
          body: HomeBody(),
        ),
      ),
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
    return BlocBuilder<DumpsBloc, DumpState>(
      builder: (context, state) => Center(
        child: state is DumpHasDataState
            ? DumpList(state.data)
            : CircularProgressIndicator(),
      ),
    );
  }
}
