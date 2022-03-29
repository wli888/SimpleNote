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

  _NoteState(String this.noteName) {
    initNote();
  }

  Future<void> initNote() async {
    noteChanged = false;
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
//    noteStorage.setFilename(noteTitleController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                    noteStorage.writeFile(myController.text);
                    noteChanged = false;
                    Navigator.pop(context, null);
                    Navigator.pop(context, null);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (noteChanged == true) {
                  showAlertDialog(context);
                } else {
                  Navigator.pop(context, noteTitleController.text);
                }
              },
            );
          },
        ),
        title: Text("Note"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: noteTitleController,
            maxLines: 1,
            decoration: InputDecoration(
                //border: InputBorder.none,
                ),
            onChanged: (String title) {
              noteChanged = true;
              noteStorage.setFilename(title);
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            //reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 700),
              child: TextField(
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
            ),
          ),
        ],
      ),
/*       floatingActionButton: Stack(
        children: [
          Positioned(
            left: 30,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'exit',
              onPressed: () {
                if (noteChanged == true) {
                  showAlertDialog(context);
                } else {
                  Navigator.pop(context, noteTitleController.text);
                }
              },
              tooltip: 'Show me the value!',
              child: Text("Exit"),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 20,
            child: FloatingActionButton(
                heroTag: 'save',
                onPressed: () async {
                  noteStorage.setFilename(noteTitleController.text);
                  noteStorage.writeFile(myController.text);
                  noteChanged = false;
                  //           Navigator.pop(context, noteTitleController.text);
                },
                tooltip: 'Show me the value!',
                child: Text("Save")),
          )
        ],
      ), */
    );
  }
}
