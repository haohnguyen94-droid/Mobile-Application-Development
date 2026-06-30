/*Name: Hong Nguyen
Assignemnt: Lab assignment 7 -
SQLite, Singleton, Repository, MVVM, and GetIt
Date: 06/29/2026
 */

/*Note model is a simple Dart class that represents a single note. Crucially, 
it includes toMap and fromMap methods to handle serialization and deserialization, 
which is necessary because sqflite works with Map<String, dynamic>.
*/

class Note{
  /*The unique id of the note.
  int? means the id can be an integer or null.
  It is nullable because when you create a new note,
  SQLite has not generated the id yet.
  */
  final int? id;

  /*The title of the note.final means once this Note object is created,
  the title cannot be changed inside the same object.
  */
  final String title;

  //The description/body/content of the note.
  final String description;

  /*The date the note was created, of type Dart DateTime.
  It is stored in SQLite as an ISO 8601 text string (see toMap/fromMap).
  */
  final DateTime date;

  /*Constructor for creating a Note object.
  this.id means assign the passed id value to the id property.
  required this.title means title must be provided.
  required this.description means description must be provided.
  required this.date means the creation date must be provided.
  id is optional because new notes do not have an id yet.
  */
  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  /*Converts this Note object into a Map<String, dynamic>.
  SQLite needs data in Map form when inserting or updating rows.
  */
  Map<String, dynamic>toMap(){
    return{
      'id':id, //The key 'id' must match the column name in your SQLite table.
      'title': title, //The key 'title' must match the title column in your table.
      'description': description,// The key 'description' must match the description column in your table.
      // DateTime cannot be stored directly, so convert it to an ISO 8601 string.
      'date': date.toIso8601String(),
    };
  }

  /*Factory constructor that creates a Note object from a Map.
  sqlite gives query results as Map<String, dynamic>.
  fromMap converts that map into:
  Note(id: 1, title: 'Study', description: 'Learn Flutter')
   */
  factory Note.fromMap(Map<String,dynamic>map){
    return Note(
      // Read the value from the 'id' column and put it into the id property.
      id: map['id'],
      // Read the value from the 'title' column and put it into the title property.
      title:map['title'],
      // Read the value from the 'description' column
      // and put it into the description property.
      description: map['description'],
      /* Read the 'date' column and convert the stored text back into a DateTime.
      Older notes created before this column existed may have a null date,
      so we fall back to the current date in that case. */
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : DateTime.now(),
    );
  }

}
