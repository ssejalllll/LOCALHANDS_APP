import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Beauty2Screen extends StatefulWidget {
  const Beauty2Screen({super.key});

  @override
  State<Beauty2Screen> createState() => _Beauty2ScreenState();
}

class _Beauty2ScreenState extends State<Beauty2Screen> {
  String? selectedOption; // regular, monthly, festive
  DateTime? startDate;
  DateTime? endDate;
  int bookingStep = 0; // Milestone chain: 0 = Selected

  Future<void> pickDate({required bool isStart}) async {
    DateTime initialDate = isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now());
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          bookingStep = 1; // Scheduled
          if (selectedOption != "regular" && endDate != null && picked.isAfter(endDate!)) {
            endDate = null; // Reset invalid end date
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  bool isContinueEnabled() {
    if (selectedOption == null) return false;
    if (selectedOption == "regular") return startDate != null;
    if (selectedOption == "monthly" || selectedOption == "festive") return startDate != null && endDate != null;
    return false;
  }

  void resetBooking() {
    setState(() {
      selectedOption = null;
      startDate = null;
      endDate = null;
      bookingStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> providers = [
      {
        "name": "Glow Studio",
        "rating": "4.8",
        "price": "₹₹",
        "address": "Jalgaon",
        "services": ["Facial", "Hair Spa", "Makeup"],
        "image": "assets/b1.jpg",
      },
      {
        "name": "Style Avenue",
        "rating": "4.5",
        "price": "₹₹₹",
        "address": "Faizpur",
        "services": ["Haircut", "Manicure", "Pedicure"],
        "image": "assets/b2.jpg",
      },
      {
        "name": "Glamour Spot",
        "rating": "4.7",
        "price": "₹₹",
        "address": "Bhusawal",
        "services": ["Hair Coloring", "Waxing"],
        "image": "assets/b3.jpg",
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Wallpaper
          SizedBox.expand(
            child: Image.asset(
              'assets/beauty.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "BEAUTY & SALON",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 26,
                                  letterSpacing: 1.2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Booking type options
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      buildBookingOption("Regular", "regular"),
                      const SizedBox(width: 12),
                      buildBookingOption("Monthly", "monthly"),
                      const SizedBox(width: 12),
                      buildBookingOption("Festive", "festive"),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Milestone chain
                if (bookingStep > 0) buildMilestone(),

                const SizedBox(height: 8),

                // Provider list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      return ProviderCard(
                        profile: provider,
                        onBookNow: () async {
                          // Pick dates if needed
                          if (selectedOption == null) return;

                          if (selectedOption == "regular") {
                            await pickDate(isStart: true);
                          } else {
                            await pickDate(isStart: true);
                            await pickDate(isStart: false);
                          }

                          if (isContinueEnabled()) {
                            setState(() => bookingStep = 2); // Request sent
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingOption(String title, String value) {
    bool isSelected = selectedOption == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedOption = value);
        resetBooking();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.6) : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.6)),
        ),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildMilestone() {
    final steps = ["Selected", "Scheduled", "Request Sent", "Booking Confirmed"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.asMap().entries.map((entry) {
          int idx = entry.key;
          String name = entry.value;
          bool isCompleted = bookingStep > idx;
          bool isCurrent = bookingStep == idx;
          return Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isCompleted || isCurrent ? Colors.green : Colors.grey[300],
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        "${idx + 1}",
                        style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? Colors.green : Colors.black54,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final VoidCallback onBookNow;
  const ProviderCard({super.key, required this.profile, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            child: Image.asset(
              profile["image"],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile["name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(profile["address"], style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(profile["price"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(profile["rating"]),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onBookNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Book Now", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
