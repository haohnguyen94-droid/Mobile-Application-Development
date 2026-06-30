/*Managing State with Provider
The NoteProvider is the brain of our application. It acts as a ViewModel, 
holding the UI state and exposing methods to manipulate that state. 
Our UI will listen to this provider and rebuild itself whenever the data changes.
*/

import 'package:flutter/material.dart';
import 'package:mvvm_sqlite_singleton/data/note_model.dart';
import 'package:mvvm_sqlite_singleton/di/service_locator.dart';
import 'package:mvvm_sqlite_singleton/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier{
  /*Get the NoteRepository object from get_it dependency injection.
  This means NoteProvider does not create NoteRepository manually like:
  final NoteRepository _repository = NoteRepository();
  instead, get_it gives it the registered NoteRepository instance.
  */
  final NoteRepository _repository = getIt<NoteRepository>();

  /*Private list that stores the current notes loaded from the database.
  It starts empty because no notes have been fetched yet.
  The underscore _ means this variable should only be changed inside this class.
  */
  List<Note> _notes = [];

  /*Private loading flag. false means the app is not currently loading notes.
  true means the app is currently fetching notes from the database.
   */
  bool _isLoading = false;

  /*Public getter for notes.
    Other classes/widgets can read the notes,
    but they cannot directly replace _notes.
   */
  List<Note>get notes=>_notes;

  /*Public getter for loading state.
  The UI can use this to decide whether to show a loading spinner.
   */
  bool get isLoading=>_isLoading;


  /*Fetch all notes from the repository/database.
  This is usually called when the screen first opens,
  or after insert/update/delete to refresh the list.
   */
  Future<void>fetchNotes() async{
    // Set loading to true before starting the database request.
    _isLoading = true;
    notifyListeners(); // Notify UI to show a loading indicator

    /*Ask the repository to get notes. The repository asks DBHelper.
    DBHelper asks SQLite. When the notes come back, store them in _notes.
     */
    _notes = await _repository.getNotes();

    // Loading is finished now.
    _isLoading = false;

    notifyListeners(); // Notify UI with the new data
  }

  // Add a new note.
  Future<void>addNote(Note note) async{
    // Insert the note into the database.
    await _repository.insertNote(note);
    // Fetch notes again so _notes has the latest database data.
    await fetchNotes(); //Refesh the list
  }

  // Update an existing note.
  Future<void>updateNote(Note note) async{
    // Update the note in the database.
    await _repository.updateNote(note);
    // Fetch notes again so the UI shows the updated version.
    await fetchNotes(); //Refresh the list
  }

  // Delete a note using its id.
  Future<void>deleteNote(int id) async{
    // Delete the note from the database.
    await _repository.deleteNote(id);
    // Fetch notes again so the deleted note disappears from the UI.
    await fetchNotes(); //Refresh the list
  }
}