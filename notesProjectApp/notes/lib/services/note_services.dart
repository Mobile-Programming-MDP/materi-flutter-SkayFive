import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/note.dart';

class NoteServices {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _notesCollection = _database.collection(
    'notes',
  );

  static Future<void> addNote(Note note) async {
    Map<String, dynamic> newNote = {
      'title': note.title,
      'description': note.description,
      'image_base_64': note.imageBase64,
      'latitude': note.latitude,
      'longtitude': note.longtitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _notesCollection.add(newNote);
  }

  static Future<void> updateNote(Note note) async {
    Map<String, dynamic> updateNote = {
      'title': note.title,
      'description': note.description,
      'image_base_64': note.imageBase64,
      'latitude': note.latitude,
      'longtitude': note.longtitude,
      'created_at': note.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _notesCollection.doc(note.id).update(updateNote);
  }

  static Future<void> deleteNote(Note note) async {
    await _notesCollection.doc(note.id).delete();
  }

  static Future<QuerySnapshot> retrieveNote() {
    return _notesCollection.get();
  }

  static Stream<List<Note>> getNoteList() {
    return _notesCollection.snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Note(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          imageBase64: data['image_base_64'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
          latitude: data['latitude'],
          longtitude: data['longtitude']
        );
      }).toList();
    });
  }
}
