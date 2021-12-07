import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  String _noteFile = "";

  FileStorage(String fileName) {
    this._noteFile = fileName;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  void setFilename(String filename) {
    _noteFile = filename;
  }

  Future<List<String>> readFile(String fileName) async {
    List<String> lines = [];

    try {
      final _dirPath = await _localPath;

      final _myFile = File('$_dirPath/$fileName');
      // Read the file
      lines = await _myFile.readAsLines();
      return lines;
    } catch (e) {
      print(e);
      return lines;
    }
  }

  Future<void> writeFile(String text) async {
    final _dirPath = await _localPath;

    final _myFile = File('$_dirPath/$_noteFile');
    await _myFile.writeAsString(text);
  }

  Future<void> writeNotesList(List<String> notesList) async {
    final _dirPath = await _localPath;

    final _myFile = File('$_dirPath/$_noteFile');
    await _myFile.writeAsString("");
    await Future.forEach(notesList, (element) async {
      await _myFile.writeAsString(element.toString() + "\n",
          mode: FileMode.append);
    });
  }
}
