import 'package:flutter/material.dart';
import 'package:localhands_app/view/booking.dart';
 // Make sure this is your updated BookingBottomSheet

class PlumberScreen extends StatefulWidget {
  const PlumberScreen({super.key});

  @override
  State<PlumberScreen> createState() => _PlumberScreenState();
}

class _PlumberScreenState extends State<PlumberScreen> {
  String selectedFilter = "Cost";
  bool bookingStarted = false;
  int bookingStep = 0;

  final List<String> filters = ["Cost", "Location", "Ratings", "Gender", "Urgent"];

  final List<Map<String, dynamic>> profiles = List.generate(10, (index) {
    return {
      "name": "Plumber ${index + 1}",
      "address": "Street ${index + 1}, City",
      "rating": "4.${index % 5 + 1}",
      "price": "\$${100 + index * 20}",
      "services": ["Pipe Repair", "Leak Fix", "Installation"],
      "image": "assets/plum${(index % 5) + 1}.jpeg",
    };
  });

  Widget buildMilestone() {
    final steps = ["Selected", "Scheduled", "Request Sent", "Booking Confirmed"];
    return Container(
      color: Colors.white.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isEven) {
            int stepIndex = i ~/ 2;
            bool isCompleted = bookingStep > stepIndex;
            bool isCurrent = bookingStep == stepIndex;
            return Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isCompleted || isCurrent ? Colors.green : Colors.grey[300],
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          "${stepIndex + 1}",
                          style: TextStyle(
                              color: isCurrent ? Colors.white : Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 60,
                  child: Text(
                    steps[stepIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent ? Colors.green : Colors.black54),
                  ),
                ),
              ],
            );
          } else {
            int leftStep = i ~/ 2;
            bool isCompleted = bookingStep > leftStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// Wallpaper background
          Positioned.fill(
            child: Image.asset(
              "assets/plumberwallpaper.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Optional dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          /// Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Page title
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Professional Plumbers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filters
                SizedBox(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final isSelected = selectedFilter == filter;
                      return GestureDetector(
                        onTap: () => setState(() => selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // List of Plumbers
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            // Profile Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(profile["image"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    profile["address"],
                                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(profile["rating"], style: const TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                  Text(profile["services"].join(", "),
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),

                            // Book Now
                            ElevatedButton(
                              onPressed: () {
                                BookingBottomSheet.show(
                                  context,
                                  profile,
                                  "Plumber Service",
                                  (step) {
                                    setState(() {
                                      bookingStep = step;
                                      bookingStarted = true;
                                    });
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text("Book", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Milestone pinned
          if (bookingStarted)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: buildMilestone(),
            ),
        ],
      ),
    );
  }
}
