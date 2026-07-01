/*
Name: Hong Nguyen
Assignment: Lab 8 Firebase Authentication
Date: 06/30/2026
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_authenication/di/service_locator.dart';
import 'app.dart';
import 'firebase_options.dart';

const clientId =
    '486968164701-unlk8i1k2m3lf17qb9i8bvu1cmui24v6.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator(); // set up our dependencies

  runApp(const MyApp(clientId: clientId));
}
