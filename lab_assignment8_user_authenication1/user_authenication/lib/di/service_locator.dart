/*Dependency injection setup for the app
Dependency Injection with Get_It.
To avoid creating instances of our NoteRepository everywhere, 
we'll use get_it to register it as a singleton. 
This means we can request an instance of it from anywhere in our app

***Highly effective for tech stack***
*Decoupled Architecture: It completely separates your UI from your data layer.

*Singleton Efficiency: SQLite database connections are expensive to open and
close. Using Get_it to register your repository and database helper as 
a singleton ensures that only one instance is created and 
used across the entire app lifetime.

*Simplified Testing: You can easily swap your actual SQLite repository with a
mock or fake repository for unit testing.

*Global Access: It provides a clean way to access your repositories from
anywhere in the app without passing instances through the constructor of every
single widget.

First, add the dependencies:
flutter pub add get_it provider
*/
import 'package:get_it/get_it.dart';
import 'package:user_authenication/repository/note_repository.dart';

final getIt = GetIt.instance;

void setupLocator(){
  /*A LazySingleton means the NoteRepository will only be created the first time 
  it's requested.*/
  getIt.registerLazySingleton(() => NoteRepository());
}