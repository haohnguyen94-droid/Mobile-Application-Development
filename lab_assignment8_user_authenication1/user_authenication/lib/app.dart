import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_authenication/providers/note_provider.dart';

import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.clientId});

  final String clientId;

  @override
  Widget build(BuildContext context) {
    // This must wrap MaterialApp (i.e. sit above its Navigator), not just
    // "home:"'s content - routes pushed later (AddNoteScreen, etc.) are
    // sibling overlay entries under the same Navigator, so a provider placed
    // only inside "home:" would be invisible to them.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final uid = snapshot.data?.uid;
        return ChangeNotifierProvider(
          // Recreate (and refetch) whenever the signed-in account changes,
          // so one user never sees another user's cached notes.
          key: ValueKey(uid),
          create: (context) {
            final provider = NoteProvider();
            if (uid != null) provider.fetchNotes();
            return provider;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false, // hide the DEBUG banner
            title: 'Sqflite Note Saver',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark().copyWith(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
            ), // darkTheme
            themeMode: ThemeMode.system,
            home: AuthGate(clientId: clientId),
          ),
        );
      },
    );
  }
}
