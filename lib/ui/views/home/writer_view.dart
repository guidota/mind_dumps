import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_dumps/services/FirebaseAuthService.dart';
import 'package:provider/provider.dart';

class WriterView extends StatefulWidget {
  const WriterView({
    Key key,
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
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.indigo,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animatePost() {
    _animateColor = ColorTween(
      begin: Colors.indigo,
      end: Colors.grey,
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
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Done!'),
      ),
    );
    _animateColor = ColorTween(
      begin: Colors.grey,
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
          Future.delayed(Duration(seconds: 1))
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
            labelStyle: Theme.of(context).textTheme.headline5,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          style: Theme.of(context).textTheme.headline5,
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
    var currentUser = await context.read<FirebaseAuthService>().currentUser();

    animatePost();
    // post content
    Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('dumps')
        .document()
        .setData({'content': content})
        .then((value) => postOk(context))
        .catchError(
          (e) => {
            print(e),
            postFailed(context),
          },
        );
  }
}
