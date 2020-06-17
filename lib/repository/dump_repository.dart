import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_dumps/bloc/dumps_bloc.dart';
import 'package:mind_dumps/models/User.dart';
import 'package:mind_dumps/models/dump.dart';

class FirestoreDumpRepository extends DumpRepository {
  final _loadedData = StreamController<List<MindDump>>();

  final _cache = List<MindDump>();

  final User user;

  FirestoreDumpRepository(this.user);

  @override
  void delete(MindDump mindDump) {
    if (Firestore.instance != null) {
      _cache.remove(mindDump);
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('dumps')
          .document(mindDump.id)
          .delete();
    }
  }

  @override
  void dispose() {
    _loadedData.close();
  }

  @override
  Stream<List<MindDump>> dumps() {
    return _loadedData.stream;
  }

  @override
  void refresh() {
    if (Firestore.instance != null) {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('dumps')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((event) {
        _cache.clear();
        event.documents.forEach((element) {
          _cache.add(MindDump.fromDocument(element));
        });
        _loadedData.add(_cache);
      });
    }
  }
}
