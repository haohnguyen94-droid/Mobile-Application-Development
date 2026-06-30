/*Name: Hong Nguyen
Assignemnt: Lab assignment 7 -
SQLite, Singleton, Repository, MVVM, and GetIt
Date: 06/29/2026
 */

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lab_assignment7/di/service_locator.dart';
import 'package:lab_assignment7/providers/note_provider.dart';
import 'package:lab_assignment7/ui/note_list_screen.dart';

void main(){
  // Desktop (Windows/Linux/macOS) has no native sqflite, so use the FFI factory.
  // Android/iOS use sqflite's built-in engine, so we skip this there.
  // The !kIsWeb check comes first because Platform is unavailable on web.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  setupLocator(); //set up our dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create:(context)=>NoteProvider()..fetchNotes(), // Create and fetch initial data
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // hide the DEBUG banner
        title:'Sqflite Note Saver',
        theme: ThemeData(
          primarySwatch:Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ), //darkTheme
        themeMode: ThemeMode.system,
        home: const NoteListScreen(),
      ),
    );
  }
}