import 'package:intl/intl.dart';
class Note {
  int _id;
  String _title;
  String _name;
  String _imagePath;
  Note(this._id, this._title, this._name, this._imagePath);
  int get id => _id;
  String get title => _title;
  String get content => _name;
  String get imagePath => _imagePath;
  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(id);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }
}