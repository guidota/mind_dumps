import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/auth_bloc.dart';
import 'package:mind_dumps/models/dump.dart';

class WriterView extends StatefulWidget {
  final MindDump dump;

  const WriterView({
    Key key,
    this.dump,
  }) : super(key: key);

  @override
  _WriterViewState createState() => _WriterViewState();
}

class _WriterViewState extends State<WriterView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController textController = TextEditingController();
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    _animateColor = ColorTween(
      begin: Colors.deepPurple[800],
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    textController.text = widget.dump.content;
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animatePost() {
    _animateColor = ColorTween(
      begin: _animateColor.value,
      end: Colors.amber,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    _animationController.forward();
  }

  postFailed(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Failed to save dump'),
      ),
    );
    _animationController.reverse();
  }

  postOk(BuildContext context) {
    _animateColor = ColorTween(
      begin: _animateColor.value,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    _animationController.forward().then((value) => {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Done!'),
            ),
          ),
          Future.delayed(Duration(seconds: 4))
              .then((value) => Navigator.of(context).pop()),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Dump"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _animateColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () => {_post(context, textController.text)},
        child: Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Write down all your thoughts...',
            labelStyle: Theme.of(context).textTheme.subtitle2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.all(8),
          ),
          style: Theme.of(context).textTheme.headline5,
          strutStyle: StrutStyle(),
          enableSuggestions: true,
          enableInteractiveSelection: true,
          expands: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
        ),
      ),
    );
  }

  _post(BuildContext context, String content) async {
    // get user
    var userState = context.bloc<AuthBloc>().state as Authenticated;
    var currentUser = userState.user;
    animatePost();
    var collection = Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('dumps');
    if (widget.dump.id == null || widget.dump.id.isEmpty) {
      // create
      // post content
      collection
          .document()
          .setData({
            'content': widget.dump.content,
            'timestamp': widget.dump.timestamp
          })
          .then((value) => postOk(context))
          .catchError(
            (e) => {
              print(e),
              postFailed(context),
            },
          );
    } else {
      // update
      collection
          .document(widget.dump.id)
          .updateData(widget.dump.toJson())
          .then((value) => postOk(context))
          .catchError(
            (e) => {
              print(e),
              postFailed(context),
            },
          );
    }
  }
}
