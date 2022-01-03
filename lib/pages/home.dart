import 'package:flutter/material.dart';
import 'package:simple_note/storage.dart';
import 'package:simple_note/pages/note.dart';

class SimpleNoteHome extends StatefulWidget {
  SimpleNoteHome({Key? key}) : super(key: key);

  @override
  _SimpleNoteHomeState createState() => _SimpleNoteHomeState();
}

class _SimpleNoteHomeState extends State<SimpleNoteHome> {
  List<String> noteTitles = [];
  final FileStorage notesListStorage = FileStorage("");

  @override
  void initState() {
    super.initState();
    initNotesList();
  }

  Future<void> initNotesList() async {
    notesListStorage.setFilename('SimpleNotes.txt');
    await notesListStorage.readFile('SimpleNotes.txt').then((value) => {
          setState(() {
            noteTitles.addAll(value);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("SimpleNote"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: noteTitles.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(noteTitles[index]),
              onTap: () async {
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Note(noteName: noteTitles[index]),
                  ),
                );
                if (result != null) {
                  setState(() {
                    noteTitles[index] = result;
                  });
                  notesListStorage.writeNotesList(noteTitles);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Note(noteName: "New Note"),
            ),
          );
          if (result != null) {
            setState(() {
              noteTitles.add(result);
            });
            notesListStorage.writeNotesList(noteTitles);
          }
        },
        tooltip: 'New Note',
        child: Text(
          "New Note",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
