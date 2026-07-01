import 'package:user_authenication/ui/note_list_screen.dart';
import 'package:flutter/material.dart';

// After a successful sign-in, AuthGate routes here.
// This is the Lab 7 Note Saver (SQLite, Provider, Repository, GetIt),
// now sitting behind Firebase authentication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoteListScreen();
  }
}
