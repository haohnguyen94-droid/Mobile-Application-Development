/*Name: Hong Nguyen
Assignemnt: Lab assignment 7 -
SQLite, Singleton, Repository, MVVM, and GetIt
Date: 06/29/2026
 */

/*This screen uses a Consumer<NoteProvider> widget, which listens for changes in our 
provider and rebuilds the UI accordingly. This is much cleaner than using 
a FutureBuilder or StatefulWidget for managing state.
*/

import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:lab_assignment7/providers/note_provider.dart'; 
import 'package:lab_assignment7/ui/add_note_screen.dart'; 

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  /* Format a DateTime into a short, readable string like "2026-06-29 14:30"
  without needing the intl package. padLeft(2,'0') keeps single-digit
  months/days/hours/minutes two characters wide (e.g. 6 -> "06"). */
  String _formatDate(DateTime date){
    String two(int n)=>n.toString().padLeft(2,'0');
    return '${date.year}-${two(date.month)}-${two(date.day)} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
    body: Consumer<NoteProvider>(
      builder:(context,provider,child){
        if(provider.isLoading){
          return const Center(child:CircularProgressIndicator());
        }else if (provider.notes.isEmpty){
          return const Center(
            child:Text('No notes yet. Tap + to add one!'),
          );
        }else{
          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder:(context,index){
              final note = provider.notes[index];
              return Card(
                //...UI for the note card
                child: ListTile(
                  // Show the note id along with its title.
                  title:Text('#${note.id}  ${note.title}'),
                  // Show the description on one line and the creation date below it.
                  subtitle:Text(
                    '${note.description}\nDate: ${_formatDate(note.date)}',
                  ),
                  isThreeLine: true,
                  /* trailing now holds TWO icons (edit + delete) side by side,
                  so we wrap them in a Row. mainAxisSize.min keeps the Row only
                  as wide as the icons it contains. */
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      // Pen icon to EDIT the note's title and description.
                      IconButton(
                        icon: const Icon(Icons.edit,color:Colors.teal),
                        onPressed: (){
                          // Open the input widgets pre-filled with this note.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:(context)=> AddNoteScreen(note:note),
                            ),
                          );
                        },
                      ),
                      // Trash icon to DELETE the note.
                      IconButton(
                        icon: const Icon(Icons.delete,color:Colors.red),
                        onPressed: (){
                          //Call the provider to delete the note
                          Provider.of<NoteProvider>(context,listen:false)
                          .deleteNote(note.id!);
                        },
                      ),
                    ],
                  ),
/*Provider.of<NoteProvider>(context, listen: false) is a Flutter method used to fetch a
specific NoteProvider instance without triggering widget rebuilds when state changes.
The listen: false flag isolates your UI from data updates, preventing expensive or
unnecessary UI redraws when you only need to trigger a method.  */
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context)=> AddNoteScreen(note:note),
                       ),
                      );
                   },
                  ),
                );
              },
            );
          }
        },
      ),
    floatingActionButton:FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder:(context)=> const AddNoteScreen()),
          );
        },
      ),
    );
  }
}