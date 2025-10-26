import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  final int bookingStep;
  final void Function(int) onStepChanged;
  final String category;
  final DateTime startDate;
  final DateTime? endDate;

  const ScheduleScreen({
    super.key,
    required this.profile,
    required this.bookingStep,
    required this.onStepChanged,
    required this.category,
    required this.startDate,
    this.endDate,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late int currentStep;

  @override
  void initState() {
    super.initState();
    currentStep = widget.bookingStep;
  }

  void nextStep() {
    setState(() {
      currentStep++;
      widget.onStepChanged(currentStep);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking - ${widget.profile["name"]}'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Category: ${widget.category}'),
            const SizedBox(height: 10),
            Text('Start Date: ${widget.startDate.toLocal()}'.split(' ')[0]),
            if (widget.endDate != null)
              Text('End Date: ${widget.endDate!.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextStep,
              child: Text(currentStep < 3
                  ? 'Next Step (${currentStep + 1})'
                  : 'Booking Completed'),
            ),
          ],
        ),
      ),
    );
  }
}
