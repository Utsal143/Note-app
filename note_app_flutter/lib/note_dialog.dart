import 'package:flutter/material.dart';

void showNoteDialog(
    {required BuildContext context, required Function(String) onSaved}) {
  TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add Note"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "Enter your note here"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              onSaved(textController.text);
              Navigator.of(context).pop();
            },
            child: Text("SAVE"),
          ),
        ],
      );
    },
  );
}
