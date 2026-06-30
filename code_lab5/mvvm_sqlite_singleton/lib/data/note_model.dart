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

  /*Constructor for creating a Note object.
  this.id means assign the passed id value to the id property.
  required this.title means title must be provided.
  required this.description means description must be provided.
  id is optional because new notes do not have an id yet.
  */
  Note({this.id,required this.title,required this.description});

  /*Converts this Note object into a Map<String, dynamic>.
  SQLite needs data in Map form when inserting or updating rows.
  */
  Map<String, dynamic>toMap(){
    return{
      'id':id, //The key 'id' must match the column name in your SQLite table.
      'title': title, //The key 'title' must match the title column in your table.
      'description': description,// The key 'description' must match the description column in your table.
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
    );
  }

}
