
/* Handles all raw database interactions
Add denpendencies in pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
or type in terminal flutter pub add sqflite path

*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mvvm_sqlite_singleton/data/note_model.dart';

// Database helper class for handling all raw database interactions
class DBHelper{
  /* create one single object of DBhelper
  static mean it belong to the class not to the object
  final mean it can be assigned only once
   */
  static final DBHelper _instance = DBHelper._internal(); // singleton pattern
  factory DBHelper() => _instance; // factory constructor to return the singleton instance, same data base.
  DBHelper._internal(); // private constructor to prevent external instantiation

  // Database object which it can be null or a Database instance.
  static Database? _database; // private stored database object

  /* getter name database, it will return a Future<Database> object,
  becuase database takes time, so it is asynchronous,
  async means this function can use await.
  If the database(this will open _database), 
  is not opened yet, it opens it first.
   */
  Future<Database>get database async{

  /*This checks whether the database has already been opened.
  If _database is not null, it returns the existing database.
  The ! means: non-nullable assertion operator */
    if(_database != null) return _database!;

    // if the database  has not opened, it calls _initDb() to initialize it.
    _database = await _initDb(); 
    return _database!;
  }

  // initialize the database
  Future<Database> _initDb() async{

    /*This creates the full file path for the database.
    getDatabasesPath() gives the folder where databases are stored on the device.
    Then join() combines that folder with the database filename: 'notes.db'.
    */
    String path = join(await getDatabasesPath(), 'notes.db');

    /*This opens the database.
    If the database does not exist yet, SQLite creates it.
    version: 1 means this is version 1 of your database structure.
    onCreate: _onCreate means:
    When the database is created for the first time, run the _onCreate function.
    hat function will create your tables. */
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /*This function runs only when the database is first created.
  It receives: Database bd, and database version.
  */
  Future<void> _onCreate(Database db, int version) async{
    /*runs raw SQL code on the database.
    execute() when you want to create a table or 
    run a command that does not directly return data.
    */
    await db.execute( 
    
      'CREATE TABLE notes(' //starts an SQL command.Create a table named notes.
      'id INTEGER PRIMARY KEY AUTOINCREMENT,' //creates a column named id.
      'title TEXT, description TEXT)',//creates two more columns: title & description
    );
  }

  /*function inserts a note into the database, 
  return id of the newly inserted row.
  accepts a Note object, locate in note_model.dart */
  Future<int> insertNote(Note note) async{
    //gets the database.If it is already open, it uses the existing database.
    Database db = await database; 

    //This inserts the note into the notes table. note.toMap() converts your Note object into a Map.
    return await db.insert('notes', note.toMap());
  }

  /*function gets all notes from the database.
  In the future, this will return a list of Note objects.
  */
  Future<List<Note>> getNotes() async{
    Database db = await database;
    //reads all rows from the notes table.
    final List<Map<String,dynamic>> maps = await db.query('notes');
    /*creates a list.maps.length is the number of rows returned from the database.
    If there are 5 notes, this creates a list of 5 items. i is the index */
    return List.generate(maps.length,(i){

      //This converts each database row back into a Note object.
      return Note.fromMap(maps[i]); 
    });
  }

  /*function updates an existing note in the database.
  The returned number is usually the number of rows updated.
  Usually it should return 1 if one note was updated.
   */
  Future<int> updateNote(Note note) async{
    Database db = await database;
    return await db.update(    //This updates data in a table.
      'notes',                 //updating the notes table.
      note.toMap(),            //new data you want to save.
      where: 'id = ?',         //tells SQLite which row to update,? is a placeholder.
      whereArgs: [note.id],    //replaces the ? with the note’s id.
    );
  }

  /*function named deleteNote.must pass the note id you want to delete.
   */
  Future<int> deleteNote(int id) async{
    Database db = await database;
    return await db.delete(    //calls the delete() method from sqflite.
      'notes',                 //This is the table name.
      where: 'id = ?',         //Only delete the row where the id matches,? is a placeholder.
      whereArgs: [id],         //id value you passed into the function.
    );
  }
}