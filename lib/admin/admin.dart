import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(const LocalHandsAdminApp());

class LocalHandsAdminApp extends StatefulWidget {
  const LocalHandsAdminApp({super.key});

  @override
  State<LocalHandsAdminApp> createState() => _LocalHandsAdminAppState();
}

class _LocalHandsAdminAppState extends State<LocalHandsAdminApp> {
  bool _isDarkMode = true;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalHands Admin',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
        cardColor: const Color(0xFF1C1C1C),
        iconTheme: const IconThemeData(color: Colors.white70),
        textTheme: ThemeData.dark().textTheme.copyWith(
              titleLarge: const TextStyle(color: Colors.white),
              headlineMedium: const TextStyle(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              bodyMedium: const TextStyle(color: Colors.white70),
            ),
      ),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(color: Colors.black),
              headlineMedium: const TextStyle(
                  color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
              bodyMedium: const TextStyle(color: Colors.black87),
            ),
      ),
      home: LocalHandsHomePage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class LocalHandsHomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const LocalHandsHomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LocalHandsHomePage> createState() => _LocalHandsHomePageState();
}

class _LocalHandsHomePageState extends State<LocalHandsHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [];

  final List<String> _pageTitles = [
    'Dashboard',
    'Users',
    'Workers',
    'Requests',
    'Availability',
    'Profile',
    'Settings'
  ];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const DashboardPage(),
      const UsersPage(),
      const WorkersPage(),
      const RequestsPage(),
      const AvailabilityPage(),
      const AdminProfilePage(),
      SettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ]);
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1D828E) : Colors.blueAccent,
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          Row(
            children: [
              const Icon(Icons.dark_mode),
              Switch(
                  value: isDark,
                  onChanged: widget.onThemeChanged,
                  activeColor: Colors.greenAccent),
            ],
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              _onNavTap(_pageTitles.indexOf('Profile'));
            },
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.white70 : Colors.black26,
              child: Icon(Icons.person, color: isDark ? Colors.black54 : Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_pageTitles.length, (index) {
                  final selected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onNavTap(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? (isDark ? Colors.greenAccent : Colors.green[700])
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _pageTitles[index],
                        style: TextStyle(
                          color: selected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// ----------------------------
// DashboardPage
// ----------------------------
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<_SalesData> requestsData = [
      _SalesData('Jan', 35),
      _SalesData('Feb', 28),
      _SalesData('Mar', 34),
      _SalesData('Apr', 32),
      _SalesData('May', 40),
    ];
    final List<_SalesData> userGrowthData = [
      _SalesData('Jan', 15),
      _SalesData('Feb', 22),
      _SalesData('Mar', 40),
      _SalesData('Apr', 31),
      _SalesData('May', 45),
    ];
    final List<_StatusData> requestStatusData = [
      _StatusData('Pending', 15, Colors.orangeAccent),
      _StatusData('Completed', 23, Colors.greenAccent),
      _StatusData('Rejected', 5, Colors.redAccent),
    ];
    final List<Map<String, String>> urgentRequests = [
      {'id': '#R21', 'user': 'John Doe', 'service': 'Plumbing', 'status': 'Pending'},
      {'id': '#R22', 'user': 'Anita Singh', 'service': 'Electrician', 'status': 'Pending'},
    ];
    final List<Map<String, String>> recentRequests = [
      {'id': '#R1', 'user': 'John Doe', 'service': 'Plumbing', 'status': 'Pending'},
      {'id': '#R2', 'user': 'Jane Smith', 'service': 'Electricity', 'status': 'Completed'},
      {'id': '#R3', 'user': 'Mike Brown', 'service': 'Cleaning', 'status': 'Pending'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Admin!', style: theme.textTheme.headlineMedium?.copyWith(fontSize: isMobile ? 24 : 30)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _LHStatCard(title: 'Total Users', value: '2,184', icon: Icons.people),
                SizedBox(width: 16),
                _LHStatCard(title: 'Active Workers', value: '743', icon: Icons.handyman),
                SizedBox(width: 16),
                _LHStatCard(title: 'Pending Requests', value: '38', icon: Icons.inbox),
                SizedBox(width: 16),
                _LHStatCard(title: 'Availability Slots', value: '129', icon: Icons.event_available),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Urgent Requests
          Card(
            color: Colors.red[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Urgent Requests',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID', style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text('User', style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text('Service', style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text('Status', style: TextStyle(color: Colors.white))),
                      ],
                      rows: urgentRequests.map((req) {
                        return DataRow(cells: [
                          DataCell(Text(req['id']!, style: const TextStyle(color: Colors.white))),
                          DataCell(Text(req['user']!, style: const TextStyle(color: Colors.white))),
                          DataCell(Text(req['service']!, style: const TextStyle(color: Colors.white))),
                          DataCell(Text(req['status']!, style: const TextStyle(color: Colors.yellow))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Charts
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isMobile ? 350 : 500,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Requests Over Time', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CartesianSeries<_SalesData, String>>[
                                LineSeries<_SalesData, String>(
                                  dataSource: requestsData,
                                  xValueMapper: (_SalesData sales, _) => sales.month,
                                  yValueMapper: (_SalesData sales, _) => sales.sales,
                                  name: 'Requests',
                                  color: Colors.amber,
                                  markerSettings: const MarkerSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: isMobile ? 300 : 400,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Request Status', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: SfCircularChart(
                              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                              series: <CircularSeries>[
                                PieSeries<_StatusData, String>(
                                  dataSource: requestStatusData,
                                  xValueMapper: (_StatusData data, _) => data.status,
                                  yValueMapper: (_StatusData data, _) => data.value,
                                  pointColorMapper: (_StatusData data, _) => data.color,
                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Requests
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Requests', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('User')),
                        DataColumn(label: Text('Service')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: recentRequests.map((req) {
                        return DataRow(cells: [
                          DataCell(Text(req['id']!)),
                          DataCell(Text(req['user']!)),
                          DataCell(Text(req['service']!)),
                          DataCell(Text(req['status']!, style: TextStyle(color: req['status'] == 'Completed' ? Colors.green : Colors.orange))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // User Growth Chart
          SizedBox(
            width: isMobile ? 350 : 600,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Growth This Year', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries<_SalesData, String>>[
                          LineSeries<_SalesData, String>(
                            dataSource: userGrowthData,
                            xValueMapper: (_SalesData sales, _) => sales.month,
                            yValueMapper: (_SalesData sales, _) => sales.sales,
                            name: 'Users',
                            color: Colors.blueAccent,
                            markerSettings: const MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------
// Users Page
// ----------------------------
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  final List<Map<String, String>> users = const [
    {'id': '#U1', 'name': 'John Doe', 'email': 'john@example.com', 'status': 'Active'},
    {'id': '#U2', 'name': 'Jane Smith', 'email': 'jane@example.com', 'status': 'Inactive'},
    {'id': '#U3', 'name': 'Mike Brown', 'email': 'mike@example.com', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('User ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Status')),
        ],
        rows: users.map(
          (user) {
            return DataRow(
              cells: [
                DataCell(Text(user['id']!)),
                DataCell(Text(user['name']!)),
                DataCell(Text(user['email']!)),
                DataCell(Text(user['status']!, style: TextStyle(color: user['status'] == 'Active' ? Colors.green : Colors.red))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

// ----------------------------
// Workers Page
// ----------------------------
class WorkersPage extends StatelessWidget {
  const WorkersPage({super.key});

  final List<Map<String, String>> workers = const [
    {'id': '#W1', 'name': 'Ravi Kumar', 'skill': 'Plumber', 'status': 'Available'},
    {'id': '#W2', 'name': 'Anita Singh', 'skill': 'Electrician', 'status': 'Busy'},
    {'id': '#W3', 'name': 'Suresh Patel', 'skill': 'Carpenter', 'status': 'Available'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Worker ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Skill')),
          DataColumn(label: Text('Status')),
        ],
        rows: workers.map(
          (worker) {
            return DataRow(
              cells: [
                DataCell(Text(worker['id']!)),
                DataCell(Text(worker['name']!)),
                DataCell(Text(worker['skill']!)),
                DataCell(Text(worker['status']!, style: TextStyle(color: worker['status'] == 'Available' ? Colors.green : Colors.red))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

// ----------------------------
// Requests Page
// ----------------------------
class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  final List<Map<String, String>> requests = const [
    {'id': '#R1', 'user': 'John Doe', 'service': 'Plumbing', 'status': 'Pending'},
    {'id': '#R2', 'user': 'Jane Smith', 'service': 'Electricity', 'status': 'Completed'},
    {'id': '#R3', 'user': 'Mike Brown', 'service': 'Cleaning', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Request ID')),
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Service')),
          DataColumn(label: Text('Status')),
        ],
        rows: requests.map(
          (request) {
            return DataRow(
              cells: [
                DataCell(Text(request['id']!)),
                DataCell(Text(request['user']!)),
                DataCell(Text(request['service']!)),
                DataCell(Text(request['status']!, style: TextStyle(color: request['status'] == 'Completed' ? Colors.green : Colors.orange))),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

// ----------------------------
// Availability Page
// ----------------------------
class AvailabilityPage extends StatelessWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Worker Availability Calendar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

// ----------------------------
// Admin Profile Page
// ----------------------------
class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "Admin Name");
  final TextEditingController _emailController = TextEditingController(text: "admin@example.com");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin Profile", style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(radius: 50, backgroundColor: Colors.greenAccent, child: const Icon(Icons.person, size: 50, color: Colors.white)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                    const SizedBox(height: 12),
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated')));
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ----------------------------
// Settings Page
// ----------------------------
class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(value: isDarkMode, onChanged: onThemeChanged),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ----------------------------
// Shared Widgets
// ----------------------------
class _LHStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _LHStatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.greenAccent;
    if (icon == Icons.handyman) iconColor = Colors.orangeAccent;
    if (icon == Icons.inbox) iconColor = Colors.purpleAccent;
    if (icon == Icons.event_available) iconColor = Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconColor.withAlpha(100), child: Icon(icon, color: iconColor, size: 30)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 24, color: iconColor, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}

class _StatusData {
  final String status;
  final double value;
  final Color color;
  _StatusData(this.status, this.value, this.color);
}

class _SalesData {
  final String month;
  final double sales;
  _SalesData(this.month, this.sales);
}