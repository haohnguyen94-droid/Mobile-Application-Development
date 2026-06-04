/*Name: Hong Nguyen
Class: CECS 453-Summer2026
Assignment: Business Card App
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const Businesscard());
}

class Businesscard extends StatelessWidget {
  const Businesscard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Center the whole card on screen (works on any window width)
        body: Center(
          // Constrain the card to a phone-like width so the two sections
          // share one center instead of drifting apart on a wide window.
          child: SizedBox(
            width: 340,
            child: Column(
              children: [
                // Space above the profile section
                const Spacer(flex: 3),

                // ============================================================
                // SECTION 1: Profile  (image + name + title)
                // ============================================================
                Column(
                  children: [
                    Image.asset(
                      'assets/images/image1.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hong Nguyen',
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Computer Science Student',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Gap between the two sections
                const Spacer(flex: 3),

                // ============================================================
                // SECTION 2: Contact information  (three icon + text rows)
                // ============================================================
                Column(
                  // left-align the rows so the icons stack in a column,
                  // mainAxisSize.min keeps the block compact so it can center
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, semanticLabel: 'Phone number'),
                        SizedBox(width: 12),
                        Text('+1 408 708 8180'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.alternate_email,
                            semanticLabel: 'LinkedIn profile'),
                        SizedBox(width: 12),
                        Text('hongnguyenlinkedin'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email, semanticLabel: 'Email address'),
                        SizedBox(width: 12),
                        Text('hong.nguyen02@student.csulb.edu'),
                      ],
                    ),
                  ],
                ),

                // Space below the contact section
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
