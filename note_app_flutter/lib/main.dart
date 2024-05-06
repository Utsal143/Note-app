import 'package:flutter/material.dart';
import 'package:note_app_client/note_app_client.dart';
import 'package:note_app_flutter/loading_screen.dart';
import 'package:note_app_flutter/note_dialog.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Notes>? _notes;
  Exception? _connectionException;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Notes note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Notes note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _notes == null
          ? LoadingScreen()
          : ListView.builder(
              itemCount: _notes!.length,
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(_notes![index].text),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        var note = _notes![index];
                        setState(() {
                          _notes!.remove(note);
                        });
                        _deleteNote(note);
                      },
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: _notes == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                showNoteDialog(
                  context: context,
                  onSaved: (text) {
                    var note = Notes(
                      text: text,
                    );
                    setState(() {
                      _notes!.add(note);
                    });

                    _createNote(note);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
