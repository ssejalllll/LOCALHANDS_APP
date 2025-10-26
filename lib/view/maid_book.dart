import 'package:flutter/material.dart';
import 'package:localhands_app/view/scheduleScreen.dart';
import 'pick_date.dart';


class MaidBookingScreen extends StatefulWidget {
  final String bookingType;
   final DateTime startDate;
  final DateTime? endDate;

  const MaidBookingScreen({super.key, required this.bookingType,
  required this.startDate, this.endDate});

  @override
  State<MaidBookingScreen> createState() => _MaidBookingScreenState();
}

class _MaidBookingScreenState extends State<MaidBookingScreen> {
  final List<Map<String, dynamic>> maids = [
    {
      'name': 'Anita',
      'image': 'assets/maid1.jpg',
      'rating': 4.5,
      'experience': 3,
      'cost': 300,
      'services': ['Cleaning', 'Cooking', 'Laundry'],
    },
    {
      'name': 'Sunita',
      'image': 'assets/maid2.jpg',
      'rating': 4.8,
      'experience': 5,
      'cost': 400,
      'services': ['Cleaning', 'Dishwashing'],
    },
    {
      'name': 'Rekha',
      'image': 'assets/maid3.jpg',
      'rating': 4.2,
      'experience': 2,
      'cost': 250,
      'services': ['Cleaning', 'Ironing'],
    },
  ];

  Future<void> openSchedule(Map<String, dynamic> maid) async {
  DateTime startDate = widget.startDate;
  DateTime? endDate = widget.endDate;

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ScheduleScreen(
        profile: maid,
        bookingStep: 0,
        onStepChanged: (_) {},
        category: widget.bookingType,
        startDate: startDate,
        endDate: endDate,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("${widget.bookingType} Maids"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D828E), Color(0xFF32BD75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: maids.length,
            itemBuilder: (context, index) {
              final maid = maids[index];
              return GestureDetector(
                onTap: () => openSchedule(maid),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(maid['image']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maid['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${maid['rating']}',
                                    style: const TextStyle(color: Colors.white)),
                                const SizedBox(width: 16),
                                Text('${maid['experience']} yrs',
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('₹${maid['cost']} per hour',
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(
                              (maid['services'] as List<dynamic>? ?? [])
                                  .join(", "),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
