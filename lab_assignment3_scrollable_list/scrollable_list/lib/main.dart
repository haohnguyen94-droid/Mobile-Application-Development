/*
Name: Hong Nguyen
Date: 06-05-2025
Assignment 3: Scrollable List App
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}
/*
This class represents a single artwork in the gallery, with an image and a caption. 
The image is loaded from a URL, and the caption is a simple string. 
The ArtworkCard widget displays the artwork in a card format, 
with the image on top and the caption below it. 
The MainApp widget sets up the overall structure of the app, 
including the app bar and the scrollable list of artworks.
 */
class  Artwork{
  const Artwork(this.imagePath, this.narrator);
  final String imagePath;
  final String narrator;
}

/*
The list of artworks is defined as a constant list of Artwork objects, 
which is used to populate the scrollable list in the MainApp widget. 
Each artwork has a unique image URL and a corresponding caption.
 */

const List<Artwork> narrator = [
  Artwork(
    'https://images.unsplash.com/photo-1571757767119-68b8dbed8c97?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     'Gundam is still cool'
  ),
  Artwork(
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
     'Keep calm and code on'
  ),
  Artwork(
    'https://plus.unsplash.com/premium_photo-1661873673782-88b30e6abef4?q=80&w=1632&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'Japan at night'
  ),
  Artwork(
    'https://plus.unsplash.com/premium_photo-1661964177687-57387c2cbd14?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'Mount Fuji'
  ),
  Artwork(
    'https://plus.unsplash.com/premium_photo-1711987339284-2d2148549aa1?q=80&w=1867&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'Peaceful is priceless'
  ),
  Artwork(
    'https://images.unsplash.com/photo-1429734956993-8a9b0555e122?q=80&w=1804&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'sunset is beautiful'
  )
];

/*
The ArtworkCard widget is a stateless widget that takes an Artwork object as a parameter 
and builds a card to display the artwork's image and caption.
 */
class ArtworkCard extends StatelessWidget {
  const ArtworkCard({super.key, required this.artwork});
  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            artwork.imagePath,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding:const EdgeInsets.all(16),
            child: Text(
              artwork.narrator, 
              style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }
}

/*
The MainApp widget is the main entry point of the application, 
setting up the overall structure and navigation.
 */
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Digital Art Space'),
          backgroundColor: Colors.deepPurple[100],
        ),
        body: ListView(
          children: narrator
              .map((artwork) => ArtworkCard(artwork: artwork))
              .toList(),
        ),
      ),
    );
  }
}
