/*Note model is a simple Dart class that represents a single note. Crucially,
it includes toMap and fromFirestore methods to handle serialization and
deserialization, which is necessary because Cloud Firestore works with
Map<String, dynamic> documents.
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Note{
  /*The unique id of the note.
  String? means the id can be a Firestore document id or null.
  It is nullable because when you create a new note,
  Firestore has not generated the document id yet.
  */
  final String? id;

  /*The title of the note.final means once this Note object is created,
  the title cannot be changed inside the same object.
  */
  final String title;

  //The description/body/content of the note.
  final String description;

  /*The date the note was created, of type Dart DateTime.
  It is stored in Firestore as a Timestamp (see toMap/fromFirestore).
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
  Firestore needs data in Map form when setting/updating a document.
  The document id itself is not stored as a field - Firestore already
  tracks it as the document's key.
  */
  Map<String, dynamic>toMap(){
    return{
      'title': title, //The key 'title' must match the field name in Firestore.
      'description': description,// The key 'description' must match the field name in Firestore.
      // DateTime cannot be stored directly, so convert it to a Firestore Timestamp.
      'date': Timestamp.fromDate(date),
    };
  }

  /*Factory constructor that creates a Note object from a Firestore document.
  id is the document id (assigned by Firestore), and data is the document's
  field map, e.g.:
  Note.fromFirestore('abc123', {'title': 'Study', 'description': 'Learn Flutter', 'date': Timestamp(...)})
   */
  factory Note.fromFirestore(String id, Map<String,dynamic>data){
    return Note(
      // The document id, not a field inside the document.
      id: id,
      // Read the value from the 'title' field and put it into the title property.
      title: data['title'],
      // Read the value from the 'description' field
      // and put it into the description property.
      description: data['description'],
      /* Read the 'date' field and convert the stored Timestamp back into a DateTime.
      Notes without a date fall back to the current date. */
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

}
