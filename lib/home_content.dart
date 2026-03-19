import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/session.dart';
import './pages/session_detail.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Session _copySession(Session session) {
    return Session(
      distance: session.distance,
      timeInSeconds: session.timeInSeconds,
      stroke: session.stroke,
      intensity: session.intensity,
      date: session.date,
      preWorkoutMeal: session.preWorkoutMeal,
      postWorkoutMeal: session.postWorkoutMeal,
      energyLevel: session.energyLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Session>('sessions');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Session> box, _) {
        if (box.isEmpty) {
          return const Center(
            child: Text("No sessions yet"),
          );
        }

        final sessions = box.values.toList().reversed.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            final restoredSession = _copySession(session);

            return Dismissible(
              key: ValueKey(session.key ?? '${session.date.microsecondsSinceEpoch}-$index'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                final deletedStroke = session.stroke;
                session.delete();

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$deletedStroke session deleted'),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        box.add(restoredSession);
                      },
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.pool,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: Text(
                    "${session.distance.toStringAsFixed(0)} m",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "${session.stroke} - ${session.intensity}\n${_formatDate(session.date)}",
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDuration(session.timeInSeconds),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Swipe to delete',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SessionDetailPage(session: session),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
