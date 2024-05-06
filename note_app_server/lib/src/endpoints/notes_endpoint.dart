import 'package:serverpod/server.dart';

import '../generated/protocol.dart';

class NotesEndpoint extends Endpoint {
  Future<List<Notes>> getAllNotes(Session session) async {
    // By ordering by the id column, we always get the notes in the same order
    // and not in the order they were updated.
    return await Notes.db.find(
      session,
      orderBy: (t) => t.id,
    );
  }

  Future<void> createNote(Session session, Notes note) async {
    await Notes.db.insertRow(session, note);
  }

  Future<void> deleteNote(Session session, Notes note) async {
    await Notes.db.deleteRow(session, note);
  }
}
