import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My first App'),
        ),
        body: const Center(
          child: Text('Hong Nguyen'),
        ),
      ),
    ),
  );
}