import 'package:flutter/material.dart';

class TitleHero extends StatelessWidget {
  const TitleHero({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'mind_dumps',
      child: Text('Mind Dumps'),
    );
  }
}
