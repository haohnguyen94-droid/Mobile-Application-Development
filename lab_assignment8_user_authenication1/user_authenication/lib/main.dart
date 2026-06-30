/*
Name: Hong Nguyen
Assignment: Lab 8 Firebase Database
Date: 06/30/2026
 */

import 'package:firebase_core/firebase_core.dart';                  // Add this import
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';                                     // And this import

// TODO(codelab user): Get API key
const clientId = '486968164701-unlk8i1k2m3lf17qb9i8bvu1cmui24v6.apps.googleusercontent.com';

void main() async {
  // Add from here...
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // To here.

  runApp(const MyApp(clientId: clientId));
}