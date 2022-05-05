import 'package:flutter/material.dart';
import 'package:simple_note/storage.dart';

class Note extends StatefulWidget {
  const Note({Key? key, required String this.noteName}) : super(key: key);

  final String noteName;

  @override
  _NoteState createState() => _NoteState(this.noteName);
}

class _NoteState extends State<Note> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final myController = TextEditingController();
  final noteTitleController = TextEditingController(text: "Title Note");
  final FileStorage noteStorage = FileStorage("");
  String noteName;
  late bool noteChanged;
  late bool noteNameChanged;

  // ignore: type_init_formals
  _NoteState(String this.noteName) {
    initNote();
  }

  // initNote gets the contents of the note if it exists
  Future<void> initNote() async {
    noteChanged = false;
    noteNameChanged = false; // name of the note has been edited
    await noteStorage.readFile(noteName).then((value) => {
          setState(() {
            myController.text = "";
            value.forEach((element) {
              myController.text = myController.text + element + "\n";
            });
            noteTitleController.text = noteName;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // showAlertDialog handles any changes made to the note, and uses
  // Navigator.pop to return to the main page
  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Warning"),
              content: Text(
                  "You have made changes. Do you want to save the changes?"),
              actions: [
                TextButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    noteStorage.setFilename(noteTitleController.text);
                    await noteStorage.writeFile(myController.text);
                    noteChanged = false;
                    Navigator.pop(context, null);
                    Navigator.pop(context, noteTitleController.text);
                  },
                ),
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context, null);
                    Navigator.pop(context, null);
                  },
                ),
              ],
            ));
  }

  // Checks whether the renamed name of the note already exists.
  // If so, it reverts back to the original name of the note
  handleNoteNameChanged(String newNoteName) async {
    if (newNoteName != noteName) {
      await noteStorage.checkFileExists(newNoteName).then((value) => {
            if (value == true)
              {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Warning"),
                          content: Text(
                              "The note name already exists. Reverting note name"),
                        )),
                noteTitleController.text = noteName,
                noteNameChanged = false
              }
            else
              {noteNameChanged = true}
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // the arrow back icon. it handles going back to the main page
        // and any changes made to the note.
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (noteNameChanged == true) {
                  await handleNoteNameChanged(noteTitleController.text);
                  // if changed note name is valid continue
                  if (noteNameChanged == true) {
                    if (noteChanged == true) {
                      showAlertDialog(context);
                    } else {
                      noteStorage.setFilename(noteTitleController.text);
                      await noteStorage.writeFile(myController.text);
                      Navigator.pop(context, noteTitleController.text);
                    }
                  }
                } else {
                  if (noteChanged == true) {
                    showAlertDialog(context);
                  } else {
                    Navigator.pop(context, noteTitleController.text);
                  }
                }
              },
            );
          },
        ),
        // the name/title of the note. Changes to the name of the note
        // will be marked.
        title: TextField(
          controller: noteTitleController,
          maxLines: 1,
          decoration: InputDecoration(
              //border: InputBorder.none,
              ),
          onSubmitted: (String newNoteName) {
            if (newNoteName != noteName) {
              handleNoteNameChanged(newNoteName);
            } else {
              noteNameChanged = false;
            }
          },
          onChanged: (String newNoteName) {
            if (newNoteName != noteName) {
              noteNameChanged = true;
            } else {
              noteNameChanged = false;
            }
          },
        ),
        centerTitle: true,
      ),
      // the contents of the note itself.
      body: ListView(
        children: [
          TextField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (String text) {
              noteChanged = true;
            },
          ),
        ],
      ),
    );
  }
}
