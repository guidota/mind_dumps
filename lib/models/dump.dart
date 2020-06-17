import 'package:cloud_firestore/cloud_firestore.dart';

class MindDump {
  String _id;
  String _content;
  Timestamp _timestamp;

  MindDump(this._id, this._content, this._timestamp);

  MindDump.map(dynamic obj) {
    this._id = obj['id'];
    this._content = obj['content'];
    this._timestamp = obj['timestamp'];
  }

  MindDump.empty() {
    this._id = "";
    this._content = "";
    this._timestamp = Timestamp.now();

  }

  String get id => _id;
  String get content => _content;
  Timestamp get timestamp => _timestamp;
  String get date => readTimestamp(_timestamp);

  MindDump.fromDocument(DocumentSnapshot snapshot) {
    this._id = snapshot.documentID;
    this._content = snapshot.data['content'];
    this._timestamp = snapshot.data['timestamp'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': _id,
      'content': _content,
      'timestamp': _timestamp
    };
  }

  String readTimestamp(Timestamp timestamp) {
    var now = new DateTime.now();
    var date = timestamp.toDate();
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0) {
      time = 'NOW';
    } else if (diff.inMinutes > 0 && diff.inHours == 0) {
      time = diff.inMinutes.toString() + ' minutes ago';
    } else if (diff.inHours > 0 && diff.inDays == 0) {
      time = diff.inHours.toString() + ' hrs ago';
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    }

    return time;
  }
}
