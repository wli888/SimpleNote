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
    // SimpleNotes.txt contains the names of the notes of the application.
    notesListStorage.setFilename('SimpleNotes.txt');
    await notesListStorage.readFile('SimpleNotes.txt').then((value) => {
          setState(() {
            noteTitles.addAll(value);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SimpleNote"),
        centerTitle: true,
      ),
      // list of notes
      body: ListView.builder(
        itemCount: noteTitles.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(noteTitles[index]),
              onTap: () async {
                //onTap to open the note
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Note(noteName: noteTitles[index]),
                  ),
                );
                // 'result' contains the title name of the note
                // if changes were made to the note
                if (result != null) {
                  setState(() {
                    noteTitles[index] = result;
                  });
                  await notesListStorage.writeNotesList(noteTitles);
                }
              },
              //onLongPress: () => print(noteTitles[index]),
            ),
          );
        },
      ),
      // New Note button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Note(noteName: "New Note"),
            ),
          );
          // 'result' contains the title name of the new note
          // if it is non-null the title will be added to the list of note names
          if (result != null) {
            setState(() {
              noteTitles.add(result);
            });
            await notesListStorage.writeNotesList(noteTitles);
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
