import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  final int bookingStep;
  final ValueChanged<int> onStepChanged;

  const ScheduleScreen({
    super.key,
    required this.profile,
    required this.bookingStep,
    required this.onStepChanged,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  String? selectedTime;
  bool requestSent = false;

  // Animation controller for screen transition
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            bool isCompleted = widget.bookingStep > stepIndex;
            bool isCurrent = widget.bookingStep == stepIndex;
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
            bool isCompleted = widget.bookingStep > leftStep;
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
    return FadeTransition(
      opacity: _opacityAnim,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1D828E), Color(0xFF1D828)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Schedule Service", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: Column(
          children: [
            // Milestone pinned
            buildMilestone(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(widget.profile["image"]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.profile["name"],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(widget.profile["rating"],
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(widget.profile["price"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Calendar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 300,
                        child: CalendarDatePicker(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          onDateChanged: (date) {
                            setState(() => selectedDate = date);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Time slots
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(8, (index) {
                          String time = "${9 + index}:00 AM";
                          bool isSelected = selectedTime == time;
                          return ChoiceChip(
                            label: Text(time),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => selectedTime = time);
                            },
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Send Request Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedDate != null && selectedTime != null && !requestSent
                      ? () {
                          setState(() => requestSent = true);
                          widget.onStepChanged(2); // Request Sent
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: requestSent ? Colors.grey : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Send Request", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
