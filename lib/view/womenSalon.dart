import 'dart:developer';
import 'package:flutter/material.dart';

class HomewomenSpa extends StatelessWidget {
  const HomewomenSpa({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"title": "HairCare", "image": "assets/images/haircare.jpeg"},
      {"title": "Waxing", "image": "assets/images/waxing.jpeg"},
      {"title": "Massage", "image": "assets/images/massage.jpeg"},
      {"title": "Manicure", "image": "assets/images/manicure.jpeg"},
      {"title": "Pedicure", "image": "assets/images/pedicure.jpeg"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Title Row ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Salon for Women",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () {
                  log("View More clicked");
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // --- Horizontal scrollable cards ---
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        item["image"],
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          item["title"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // --- Full-width offer container ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // Background image
                  Image.asset(
                    "assets/images/offerdoorbell.jpeg",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),

                  // Top Text
                  Positioned(
                    top: 16,
                    left: 16,
                    child: const Text(
                      "Camera.Doorbell\nAll-in-one.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom "Buy Now" button
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          log("Buy Now clicked");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        ),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
