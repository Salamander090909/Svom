import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/session.dart';
import './pages/session_detail.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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

            return Card(
              child: ListTile(
                title: Text("${session.distance}m • ${session.stroke}"),
                subtitle: Text(
                  "${session.intensity} • ${session.date.day}.${session.date.month}.${session.date.year}",
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
            );
          },
        );
      },
    );
  }
}