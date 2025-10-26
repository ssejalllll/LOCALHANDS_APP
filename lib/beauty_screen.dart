import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beauty2.dart'; // Import the second screen

class BeautyScreen extends StatefulWidget {
  const BeautyScreen({super.key});

  @override
  State<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen wallpaper
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/beauty.jpg'), // wallpaper
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Optional transparent overlay for readability
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Column(
              children: [
                // 🔙 Back button + Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      // ✅ Title centered
                      Expanded(
                        child: Center(
                          child: Text(
                            "Beauty & SALON",
                            style: GoogleFonts.lobster(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Empty box to balance spacing
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(), // Push buttons slightly up from bottom

                // Women / Men buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Beauty2Screen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 3, 3, 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Women",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Beauty2Screen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 8, 8, 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Men",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60), // space from bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
