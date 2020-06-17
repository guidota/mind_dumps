import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_dumps/bloc/dumps_bloc.dart';
import 'package:mind_dumps/models/dump.dart';

import '../writer_view.dart';

class DumpList extends StatefulWidget {
  final List<MindDump> dumps;

  DumpList(this.dumps);

  @override
  _DumpListState createState() => _DumpListState();
}

class _DumpListState extends State<DumpList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.dumps.length,
      itemBuilder: (context, index) => DumpItem(
        mindDump: widget.dumps[index],
        onSelected: () => setState(() {
          this.selectedIndex = index;
        }),
        selected: this.selectedIndex == index,
      ),
    );
  }
}

class DumpItem extends StatefulWidget {
  final MindDump mindDump;
  final VoidCallback onSelected;
  final bool selected;

  const DumpItem({Key key, this.mindDump, this.onSelected, this.selected})
      : super(key: key);

  @override
  _DumpItemState createState() => _DumpItemState();
}

class _DumpItemState extends State<DumpItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedContainer(
        height: widget.selected ? 100 : 60,
        duration: Duration(milliseconds: 200),
        child: ListTile(
          title: Text(
            widget.mindDump.date,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          subtitle: Text(
            widget.mindDump.content.length > 30
                ? widget.mindDump.content.substring(0, 30) + "..."
                : widget.mindDump.content,
            softWrap: widget.selected,
          ),
          selected: widget.selected,
          trailing: widget.selected
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriterView(
                            dump: widget.mindDump,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      onPressed: () => _deleteMindDump(context, widget.mindDump),
                    ),
                  ],
                )
              : null,
          onTap: widget.onSelected,
        ),
      ),
    );
  }

  _deleteMindDump(BuildContext context, MindDump mindDump) {
    context.repository<DumpRepository>().delete(mindDump);
  }
}
