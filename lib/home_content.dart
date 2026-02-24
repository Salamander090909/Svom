import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/session.dart';
import 'pages/session_detail.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Session>('sessions');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Swim Sessions',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<Session> box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: Text(
                        'No sessions yet. Press + to add your first session.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final sessions = box.values.toList()
                    ..sort((a, b) => b.date.compareTo(a.date));

                  return ListView.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return Card(
                        child: ListTile(
                          title: Text('${session.distance.toStringAsFixed(0)} m'),
                          subtitle: Text(
                            '${session.stroke} • ${_formatTime(session.timeInSeconds)}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SessionDetailPage(session: session),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
