import 'dart:async';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localhands_app/login_screen.dart';
import 'package:localhands_app/plumber_screen.dart';
import 'package:localhands_app/view/womenSalon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> services = [
    {"icon": Icons.content_cut, "title": "Salon"},
    {"icon": Icons.plumbing, "title": "Plumbing"},
    {"icon": Icons.family_restroom, "title": "BabySitter"},
    {"icon": Icons.cleaning_services, "title": "Maid"},
    {"icon": Icons.local_dining, "title": "Caterers"},
  ];

  String location = "Fetching location...";
  late AnimationController _animationController;

  final List<Map<String, dynamic>> serviceInfoCards = [
    {
      "title": "Maid",
      "description": "Reliable and professional maid services for your home.",
      "image": "assets/images/housemaid.jpeg",
    },
    {
      "title": "Caterers",
      "description": "Delicious catering services for all your events.",
      "image": "assets/images/caterers.jpeg",
    },
    {
      "title": "Babysitter",
      "description": "Experienced babysitters to take care of your little ones.",
      "image": "assets/images/child-care.jpeg",
    },
  ];

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _carouselTimer;

 
 //init state

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pageController = PageController(initialPage: 0,viewportFraction: 1.0);

    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % serviceInfoCards.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Location services disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => location = "Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => location = "Permission denied forever");
      return;
    }

    final pos =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      location =
          "${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}";
    });
  }

  String getCurrentDay() {
    final now = DateTime.now();
    final weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return weekdays[now.weekday - 1];
  }

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(now);
  }

  String getFestivalGreeting() {
    final now = DateTime.now();
    if (now.month == 10 && now.day == 4) return "✨ Happy Navratri ✨";
    if (now.month == 11 && now.day == 1) return "🎇 Happy Diwali 🎇";
    if (now.month == 12 && now.day == 25) return "🎄 Merry Christmas 🎄";
    return "Have a great day! 😊";
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body:  CustomScrollView(
  slivers: [
    SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      expandedHeight: screenHeight * 0.55,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildTopSection(screenHeight),
      ),
      automaticallyImplyLeading: false,
      // Remove title here; search bar will be in persistent header
    ),
    // Sticky Search Bar
    SliverPersistentHeader(
      pinned: true,
      delegate: _SearchBarDelegate(searchBar: _buildSearchBar()),
    ),

    SliverToBoxAdapter(child: _buildServicesSection()),
    SliverToBoxAdapter(child: const SizedBox(height: 16)),
    SliverToBoxAdapter(child: _buildPromotionCard()),
    SliverToBoxAdapter(child: const SizedBox(height: 16)),
    SliverToBoxAdapter(child: _buildDiscoverAllServices()),
    SliverToBoxAdapter(child: const SizedBox(height: 16)),
    SliverToBoxAdapter(child: _buildOffersCard()),
    SliverToBoxAdapter(child: const SizedBox(height: 80)),
    SliverToBoxAdapter(child: const SizedBox(height: 8)),
    SliverToBoxAdapter(child: const HomewomenSpa()),
    SliverToBoxAdapter(child: const SizedBox(height: 16)),
  ],
),



      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  

  Widget _buildTopSection(double screenHeight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
             colors: [hexToColor("#1D828E"), hexToColor("#1A237E")],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _StringLightsPainter(animation: _animationController),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 28),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Your Location",
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(location,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Hello, Anushri 👋",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${getCurrentDay()}, ${getCurrentDate()}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Carousel
              SizedBox(
  height: screenHeight * 0.35,
  child: PageView.builder(
    controller: _pageController,
    itemCount: serviceInfoCards.length,
    onPageChanged: (page) => setState(() => _currentPage = page),
    itemBuilder: (context, index) {
      double scale = _currentPage == index ? 1.0 : 0.85;
      return TweenAnimationBuilder(
        tween: Tween(begin: scale, end: scale),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Card Image
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              height: screenHeight * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  serviceInfoCards[index]["image"],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            // Text & Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceInfoCards[index]["title"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      serviceInfoCards[index]["description"],
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: const [
            Icon(Icons.search, color: Color.fromARGB(137, 11, 9, 9)),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: TextStyle(color: Color.fromARGB(221, 14, 11, 11)),
                decoration: InputDecoration(
                  hintText: "Search services...",
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Popular Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(
                  services[index]["icon"], services[index]["title"]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          if(title=="Plumbing"){
            Navigator.push(context,MaterialPageRoute(builder:(_)=>const PlumberScreen()),         //plumber screen
            );
          }

        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.blueGrey[900]),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                "assets/images/explore.jpeg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Special Offer! Get 20% off on your first booking.",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      "Explore",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverAllServices() {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Discover All Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: allServices.length,
            itemBuilder: (context, index) {
              final item = allServices[index];

              return InkWell(
                onTap:(){
                  if(item["title"]=="Plumbing"){
                    Navigator.push(
                      context,MaterialPageRoute(builder:(_)=>PlumberScreen()),
                    );
                  }
                },

                borderRadius: BorderRadius.circular(12),
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey[50],
                    child: Icon(item["icon"], color: Colors.blueGrey[900]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["title"],
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
                 ),   );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOffersCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black, const Color.fromARGB(255, 107, 27, 3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Center(
          child: Text(
            "🎉 Limited Time Offer!",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
    );
    


  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [hexToColor("#1D828E"), hexToColor("#1A237E")],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/profile.jpg")),
                SizedBox(height: 10),
                Text("Anushri Vaidya",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Torna Girls Hostel, Ambegaon, Pune",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StringLightsPainter extends CustomPainter {
  final Animation<double> animation;

  _StringLightsPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final bulbPaint = Paint()..style = PaintingStyle.fill;
    final wirePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.5);

    final centerX = size.width / 2;
    final topY = 0.0;
    final centerLeftX = size.width * 0.15;
    final centerRightX = size.width * 0.85;
    final centerY = size.height * 0.3;

    _drawString(canvas, animation, centerX, topY, centerLeftX, centerY, wirePaint, bulbPaint);
    _drawString(canvas, animation, centerX, topY, centerRightX, centerY, wirePaint, bulbPaint);
  }

  void _drawString(Canvas canvas, Animation<double> animation,
      double topX, double topY, double endX, double endY, Paint wirePaint, Paint bulbPaint) {
    final path = Path();
    path.moveTo(topX, topY);
    path.quadraticBezierTo((topX + endX) / 2, topY + 50, endX, endY);
    canvas.drawPath(path, wirePaint);

    int bulbs = 8;
    for (int i = 0; i <= bulbs; i++) {
      double t = i / bulbs;
      double x = (1 - t) * (1 - t) * topX + 2 * (1 - t) * t * ((topX + endX) / 2) + t * t * endX;
      double y = (1 - t) * (1 - t) * topY + 2 * (1 - t) * t * (topY + 50) + t * t * endY;

      bool isOn = ((animation.value * 10).floor() + i) % 2 == 0;
      bulbPaint.color = isOn ? Colors.yellowAccent : Colors.yellowAccent.withOpacity(0.2);
      bulbPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(x, y), 6, bulbPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget searchBar;
  _SearchBarDelegate({required this.searchBar});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: searchBar,
    );
  }

  @override
  double get maxExtent => 60; // height of your search bar
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

