import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionDetailPage extends StatelessWidget {
  final Session session;

  const SessionDetailPage({super.key, required this.session});

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              '${session.distance} m',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              formatTime(session.timeInSeconds),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey),
            ),
            const SizedBox(height: 30),

            const Text('Stroke',
                style: TextStyle(color: Colors.grey)),
            Text(session.stroke,
                style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            const Text('Intensity',
                style: TextStyle(color: Colors.grey)),
            Text(session.intensity,
                style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 30),

            const Text('Nutrition',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Text(
                'Pre: ${session.preWorkoutMeal ?? "Not logged"}'),
            const SizedBox(height: 6),
            Text(
                'Post: ${session.postWorkoutMeal ?? "Not logged"}'),

            const SizedBox(height: 20),

            const Text('Energy',
                style: TextStyle(color: Colors.grey)),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index <
                          (session.energyLevel ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}