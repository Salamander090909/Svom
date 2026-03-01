import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/session.dart';

class NewSessionPage extends StatefulWidget {
  const NewSessionPage({super.key});

  @override
  State<NewSessionPage> createState() => _NewSessionPageState();
}

class _NewSessionPageState extends State<NewSessionPage> {
  final _distanceController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _preMealController = TextEditingController();
  final _postMealController = TextEditingController();

  String _stroke = 'Freestyle';
  String _intensity = 'Medium';
  int _energy = 3;

  final List<String> _strokes = [
    'Freestyle',
    'Breaststroke',
    'Backstroke',
    'Butterfly',
  ];

  final List<String> _intensities = [
    'Low',
    'Medium',
    'High',
  ];

  void _saveSession() {
    final distance = double.tryParse(_distanceController.text);
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final time = minutes * 60 + seconds;

    if (distance == null || seconds >= 60 || time == 0) return;

    final session = Session(
      distance: distance,
      timeInSeconds: time,
      stroke: _stroke,
      intensity: _intensity,
      date: DateTime.now(),
      preWorkoutMeal:
          _preMealController.text.isEmpty ? null : _preMealController.text,
      postWorkoutMeal:
          _postMealController.text.isEmpty ? null : _postMealController.text,
      energyLevel: _energy,
    );

    Hive.box<Session>('sessions').add(session);
    Navigator.pop(context);
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Session')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Workout'),

            dropdownField(
              label: 'Stroke',
              value: _stroke,
              items: _strokes,
              onChanged: (value) {
                setState(() {
                  _stroke = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            dropdownField(
              label: 'Intensity',
              value: _intensity,
              items: _intensities,
              onChanged: (value) {
                setState(() {
                  _intensity = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Distance (m)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            sectionTitle('Nutrition'),

            TextField(
              controller: _preMealController,
              decoration: const InputDecoration(
                labelText: 'Pre workout meal',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _postMealController,
              decoration: const InputDecoration(
                labelText: 'Post workout meal',
                border: OutlineInputBorder(),
              ),
            ),

            sectionTitle('Energy'),

            Slider(
              value: _energy.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: _energy.toString(),
              onChanged: (v) {
                setState(() {
                  _energy = v.toInt();
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Session'),
              ),
            )
          ],
        ),
      ),
    );
  }
}