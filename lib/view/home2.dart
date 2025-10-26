import 'package:flutter/material.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  final List<Map<String, dynamic>> allServices = [
    {"icon": Icons.content_cut, "title": "Salon"},
    {"icon": Icons.plumbing, "title": "Plumbing"},
    {"icon": Icons.family_restroom, "title": "BabySitter"},
    {"icon": Icons.cleaning_services, "title": "Maid"},
    {"icon": Icons.local_dining, "title": "Caterers"},
    {"icon": Icons.electric_bolt, "title": "Electrician"},
    {"icon": Icons.car_repair, "title": "Car Wash"},
    {"icon": Icons.computer, "title": "Computer Repair"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredServices = allServices
        .where((service) =>
            service["title"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Services"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search services...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of services
            Expanded(
              child: GridView.builder(
                itemCount: filteredServices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = filteredServices[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(item["icon"], size: 36, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["title"],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
