/*A repository abstracts the data source from the rest of the app.
 * Our business logic (in the NoteProvider) will talk to the NoteRepository, 
 * not directly to the DBHelper.
 * 
 * If we ever wanted to switch from SQLite to a
 * cloud database like Firebase, we would only need to change the implementation 
 * inside the repository—the rest of the app would remain untouched.
 */

import 'package:user_authenication/data/db_helper.dart';
import 'package:user_authenication/data/note_model.dart';

class NoteRepository {
  /* Create an instance of DBHelper.
  _dbHelper is private because it starts with '_'
  so it can only be used inside this file/library.
  DBHelper() returns the singleton DBHelper instance,
  because your DBHelper class uses the singleton pattern.
  */
  final DBHelper _dbHelper = DBHelper();

  /* Get all notes from the database.
  This simply calls the getNotes() method inside DBHelper.
  Future<List<Note>> means:
  "This will return a list of Note objects later."
  */
  Future<List<Note>>getNotes()=>_dbHelper.getNotes();

  /* Insert a new note into the database.
  It receives a Note object and passes it to DBHelper.
   */
  Future<void>insertNote(Note note)=>_dbHelper.insertNote(note);

  //Update an existing note in the database.
  Future<void>updateNote(Note note)=>_dbHelper.updateNote(note);

  /*Delete a note from the database using its Firestore document id.
   */
  Future<void>deleteNote(String id)=>_dbHelper.deleteNote(id);
}