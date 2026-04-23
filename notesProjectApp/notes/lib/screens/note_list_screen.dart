import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_services.dart';
import 'package:notes/widgets/note_dialog.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NoteDialog();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NoteServices.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.hasError}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NoteDialog(note: document);
                        },
                      );
                    },

                    title: Text(document.title),
                    subtitle: Text(document.description),
                    trailing: InkWell(
                      onTap: () {
                        showAlertDialog(context, document);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }

  void showAlertDialog(BuildContext context, Note document) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('No'),
    );

    Widget continueButton = ElevatedButton(
      onPressed: () {
        NoteServices.deleteNote(document).whenComplete(() {
          Navigator.of(context).pop();
        });
      },
      child: const Text('Yes'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Delete Note'),
      content: const Text('Are You Sure To delete Note'),
      actions: [cancelButton, continueButton],
    );

    // show The Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
