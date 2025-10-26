import 'package:flutter/material.dart';
import 'package:localhands_app/beauty_screen.dart';
import 'package:localhands_app/plumber_screen.dart';
import 'package:localhands_app/view/maid.dart';
import 'package:localhands_app/view/womenSalon.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final List<Map<String, dynamic>> allServices = [
    {
      "title": "Salon for Women",
      "image": "assets/services/salonservice.jpg",
      "screen": const BeautyScreen(),
    },
    {
      "title": "Plumber",
      "image": "assets/services/plumbingservice.jpg",
      "screen": const PlumberScreen(),
    },
    {
      "title": "Maid",
      "image": "assets/services/maidservice.jpg",
      "screen": const MaidScreen(),
    },
    {
      "title": "Baby Sitter",
      "image": "assets/child-care.jpeg",
      "screen": const MaidScreen(),
    },
    {
      "title": "Electrician",
      "image": "assets/services/electricianservice.jpg",
      "screen": const PlumberScreen(),
    },
    {
      "title": "Catering",
      "image": "assets/caterings.jpg",
      "screen": const PlumberScreen(),
    },
    {
      "title": "Car Wash",
      "image": "assets/services/carwash.jpg",
      "screen": const PlumberScreen(),
    },
    {
      "title": "Painting",
      "image": "assets/services/paintingservice.jpg",
      "screen": const PlumberScreen(),
    },
    {
      "title": "Computer Repair",
      "image": "assets/services/comprepair.jpg",
      "screen": const PlumberScreen(),
    },
  ];

  List<Map<String, dynamic>> displayedServices = [];

  @override
  void initState() {
    super.initState();
    displayedServices = allServices;
  }

  void filterServices(String query) {
    setState(() {
      displayedServices = allServices
          .where((service) =>
              service["title"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search services...",
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (value) => filterServices(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Services"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: displayedServices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final service = displayedServices[index];
                  return _buildServiceCard(context, service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => service["screen"]),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                service["image"],
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(
                  service["title"],
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
      ),
    );
  }
}
