import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

/*This is a stateless widget that serves as the root of the application,
the widget that's passed into runApp.Inside the build method, 
it returns a Material App widget
containing the three properties: title, theme & home.
The build method is overridden to return a MaterialApp widget, which is the 
main structure of the app. 
It sets the title and the home screen.Set CounterScreen as the home screen, 
which will be defined in a stateful widget to manage the counter state.
 */
class CounterApp extends StatelessWidget { 
  const CounterApp({super.key});
  @override                                
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), 
      home: CounterScreen(), 
    );
  }
}

/*CounterScreen is a stateful widget that represents the main screen of the app.
We have the overridden createState method which returns the instance of the class
CounterScreenState.
_CounterScreenState is private to the file and it will manage the state of the counter.
*/
class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}


class _CounterScreenState extends State<CounterScreen>{
  // define the counter variable
  int _counter = 0; 

  // define the incremement and decrement counter methods
  void _incrementCounter() {
    setState(() { // <= the second parenthese is basiclly lambda, meaning Pass an anonymous function into setState.
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 72),
            ),
            Row(
              mainAxisAlignment : MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Add',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Subtract',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ], // <= the first parenthese is for the children of the column, the second one is for the children of the row.
        ),
      ),
    );
  }
}


