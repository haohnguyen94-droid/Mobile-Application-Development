/*This screen uses a Consumer<NoteProvider> widget, which listens for changes in our 
provider and rebuilds the UI accordingly. This is much cleaner than using 
a FutureBuilder or StatefulWidget for managing state.
*/

import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:mvvm_sqlite_singleton/providers/note_provider.dart'; 
import 'package:mvvm_sqlite_singleton/ui/add_note_screen.dart'; 

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

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
                  title:Text(note.title),
                  subtitle:Text(note.description),
                  trailing:IconButton(
                    icon: const Icon(Icons.delete,color:Colors.red),
                    onPressed: (){
                      //Call the provider to delete the note
                      Provider.of<NoteProvider>(context,listen:false)
                      .deleteNote(note.id!);
                    },
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