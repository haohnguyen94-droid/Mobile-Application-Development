/*
Name: Hong Nguyen
Date: 06-05-2025
Assignment 2: Art Gallery App
*/

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Holds the details for a single artwork in the gallery.
class Artwork {
  const Artwork(this.imagePath, this.title, this.painter, this.completedIn);

  final String imagePath;
  final String title;
  final String painter;
  final String completedIn;

  // Pre-formatted label shown under the title.
  String get caption => '$painter ($completedIn)';
}

// Every painting the gallery can display, kept as a top-level constant
// so it is shared rather than rebuilt on each state change.
const List<Artwork> kGallery = <Artwork>[
  Artwork('assets/images/great_wave_off_kanagawa.jpg', 'The Great Wave off Kanagawa',
      'Katsushika Hokusai', '1831'),
  Artwork('assets/images/guernica.jpg', 'Guernica', 'Pablo Picasso', '1937'),
  Artwork('assets/images/the_birth_of_venus.jpg', 'The Birth of Venus',
      'Sandro Botticelli', '1486'),
  Artwork('assets/images/the_last_supper.jpg', 'The Last Supper',
      'Leonardo da Vinci', '1498'),
  Artwork('assets/images/the_persistence_of_memory.jpg', 'The Persistence of Memory',
      'Salvador Dalí', '1931'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalArtSpace(),
    );
  }
}

class DigitalArtSpace extends StatefulWidget {
  const DigitalArtSpace({super.key});

  @override
  State<DigitalArtSpace> createState() => _DigitalArtSpaceState();
}

class _DigitalArtSpaceState extends State<DigitalArtSpace> {
  static const Color _accent = Color.fromARGB(255, 24, 2, 97);
  static const Duration _slide = Duration(milliseconds: 300);

  final PageController _pager = PageController();
  int _index = 0;

  // True/false flags that drive whether each button is tappable.
  bool get _hasPrevious => _index > 0;
  bool get _hasNext => _index < kGallery.length - 1;

  // A single helper handles both directions; `step` is -1 or +1.
  void _slideBy(int step) {
    final int target = _index + step;
    if (target < 0 || target >= kGallery.length) return;
    _pager.animateToPage(target, duration: _slide, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Artwork current = kGallery[_index];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Expanded(child: _buildCarousel()),
          const SizedBox(height: 20),
          _buildInfoPanel(current),
          const SizedBox(height: 40),
          _buildControls(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // The swipeable stack of framed paintings.
  Widget _buildCarousel() {
    return PageView.builder(
      controller: _pager,
      itemCount: kGallery.length,
      onPageChanged: (int page) => setState(() => _index = page),
      itemBuilder: (BuildContext context, int i) => Center(
        child: Container(
          width: 300,
          height: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(4, 6),
              ),
            ],
          ),
          child: Container(
            width: 230,
            height: 330,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(kGallery[i].imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Title + artist/year caption for the painting on screen.
  Widget _buildInfoPanel(Artwork art) {
    return Container(
      width: 300,
      height: 80,
      color: const Color.fromARGB(255, 225, 227, 231),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            art.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
          Text(
            art.caption,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // The Previous / Next button pair.
  Widget _buildControls() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      fixedSize: const Size(136, 40),
      backgroundColor: _accent,
      foregroundColor: Colors.white,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: style,
          onPressed: _hasPrevious ? () => _slideBy(-1) : null,
          child: const Text('Previous', style: TextStyle(fontSize: 11)),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          style: style,
          onPressed: _hasNext ? () => _slideBy(1) : null,
          child: const Text('Next', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}
