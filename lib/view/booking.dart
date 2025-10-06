import 'package:flutter/material.dart';
import 'package:localhands_app/view/scheduleScreen.dart';

class BookingBottomSheet {
  static void show(BuildContext context, Map<String, dynamic> profile,
      ValueChanged<int> onStepChanged) {
    onStepChanged(0); // Set step = Selected

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        profile["image"],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name & Address
                    Text(
                      profile["name"],
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile["address"] ?? "123 Main Street, City",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Rating & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange[400], size: 20),
                            const SizedBox(width: 4),
                            Text(profile["rating"],
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Text(profile["price"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Services / Short Description
                    Text(
                      "Services Provided:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This plumber specializes in ${profile["services"].join(", ")}. "
                      "Highly experienced in handling household plumbing issues efficiently. "
                      "Customer satisfaction is guaranteed.",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    // Share icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Share logic here
                          },
                          icon: const Icon(Icons.share, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Schedule & Add to Cart Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                                // Close bottom sheet first
      Navigator.pop(context);

      // Small delay to allow bottom sheet to close
      Future.delayed(const Duration(milliseconds: 200), () {
        // Navigate to ScheduleScreen with fade transition
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ScheduleScreen(
              profile: profile,
              bookingStep: 1, // Scheduled
              onStepChanged: onStepChanged,
            ),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    },  
                            
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.white),
                            label: const Text("Schedule",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            onStepChanged(3); // Booking confirmed
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Icon(Icons.add_shopping_cart,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
