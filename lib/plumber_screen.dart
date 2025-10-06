import 'package:flutter/material.dart';
import 'package:localhands_app/view/booking.dart';

 // Make sure this file exists and contains BookingBottomSheet

class PlumberScreen extends StatefulWidget {
  const PlumberScreen({super.key});

  @override
  State<PlumberScreen> createState() => _PlumberScreenState();
}

class _PlumberScreenState extends State<PlumberScreen> {
  String selectedFilter = "Cost";
  bool bookingStarted = false;
  int bookingStep = 0;
  final List<String> filters = ["Cost", "Location", "Ratings", " Gender","Urgent"];

  final List<Map<String, dynamic>> profiles = List.generate(10, (index) {
    return {
      "name": "Plumber ${index + 1}",
      "address": "Street ${index + 1}, City",
      "rating": "4.${index % 5 + 1}",
      "price": "\$${100 + index * 20}",
      "services": ["Pipe Repair", "Leak Fix", "Installation"],
      "image": "assets/images/plum${(index % 5) + 1}.jpeg",
    };
  });

  // Milestone tracker like Amazon
  Widget buildMilestone() {
    final steps = ["Selected", "Scheduled", "Request Sent", "Booking Confirmed"];
    return Container(
      color: Colors.white,
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
                  backgroundColor: isCompleted || isCurrent ? Colors.blue : Colors.grey[300],
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
                        color: isCurrent ? Colors.blue : Colors.black54),
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
                color: isCompleted ? Colors.blue : Colors.grey[300],
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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            children: [
              // Brown top container
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.brown,
              ),
              // White container with filters and profile list
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // Filter tabs
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            final filter = filters[index];
                            final isSelected = selectedFilter == filter;
                            return GestureDetector(
                              onTap: () => setState(() => selectedFilter = filter),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Profiles list
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
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(profile["name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18)),
                                        Text(profile["address"],
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 14)),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.orange[400], size: 16),
                                            const SizedBox(width: 4),
                                            Text(profile["rating"],
                                                style: const TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                        Text(profile["services"].join(", "),
                                            style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Call bottom sheet from another file
                                      BookingBottomSheet.show(context, profile, (step) {
                                        setState(() {
                                          bookingStep = step;
                                          bookingStarted = true;
                                        });
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                    ),
                                    child: const Text("Book Now",
                                        style: TextStyle(color: Colors.white)),
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
              ),
            ],
          ),
          // Milestone banner pinned at top
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
