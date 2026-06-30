/*Name: Hong Nguyen
Assignemnt: Lab assignment 7 -
SQLite, Singleton, Repository, MVVM, and GetIt
Date: 06/29/2026
 */

/*Finally, the add/edit screen simply collects user input and calls the appropriate method
on the NoteProvider to save the data.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab_assignment7/data/note_model.dart';
import 'package:lab_assignment7/providers/note_provider.dart';

/*The StatefulWidget configuration.
note is nullable: it is null when creating a new note,
and holds an existing note when editing.
*/
class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // Key used to identify the form and run validation.
  final _formKey = GlobalKey<FormState>();
  // Controllers hold the text typed into each field.
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If we are editing an existing note, pre-fill the fields.
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    // Free the controllers when the screen is removed to avoid memory leaks.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        // For a new note use the current date; when editing, keep the
        // original creation date so it does not change on update.
        date: widget.note?.date ?? DateTime.now(),
      );

      // Use the provider to save the note.
      final provider = Provider.of<NoteProvider>(context, listen: false);
      if (widget.note == null) {
        provider.addNote(note);
      } else {
        provider.updateNote(note);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Title changes depending on whether we are creating or editing.
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text(isEditing ? 'Update Note' : 'Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
