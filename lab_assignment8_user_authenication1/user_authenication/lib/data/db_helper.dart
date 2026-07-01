/* Handles all raw database interactions.
This is the one file that knows notes live in Cloud Firestore. Everything
above it (NoteRepository, NoteProvider, the UI) still just calls
getNotes/insertNote/updateNote/deleteNote, so swapping the data source here
is the only place that had to change.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_authenication/data/note_model.dart';

// Database helper class for handling all raw database interactions
class DBHelper{
  /* create one single object of DBhelper
  static mean it belong to the class not to the object
  final mean it can be assigned only once
   */
  static final DBHelper _instance = DBHelper._internal(); // singleton pattern
  factory DBHelper() => _instance; // factory constructor to return the singleton instance, same data base.
  DBHelper._internal(); // private constructor to prevent external instantiation

  /* Every user's notes live under their own document:
  users/{uid}/notes/{noteId}
  so each signed-in account only ever reads/writes its own notes. The uid is
  read fresh on every call (not cached) since the signed-in user can change
  while this singleton stays alive for the whole app lifetime.
  */
  CollectionReference<Map<String, dynamic>> get _notesCollection {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');
  }

  /*function gets all notes from the database.
  Returns a list of Note objects built from each note document.
  */
  Future<List<Note>> getNotes() async{
    final snapshot =
        await _notesCollection.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => Note.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /*function inserts a note into the database.
  accepts a Note object, locate in note_model.dart. Firestore generates the
  new document's id automatically.
  */
  Future<void> insertNote(Note note) async{
    await _notesCollection.add(note.toMap());
  }

  /*function updates an existing note in the database.
   */
  Future<void> updateNote(Note note) async{
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  /*function named deleteNote. must pass the note's Firestore document id.
   */
  Future<void> deleteNote(String id) async{
    await _notesCollection.doc(id).delete();
  }
}
