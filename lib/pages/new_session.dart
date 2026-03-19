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

  @override
  void dispose() {
    _distanceController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _preMealController.dispose();
    _postMealController.dispose();
    super.dispose();
  }

  String? _validateSession(double? distance, int? minutes, int? seconds) {
    if (distance == null || distance <= 0) {
      return 'Please enter a valid distance greater than 0.';
    }

    if (minutes == null || minutes < 0) {
      return 'Minutes must be 0 or more.';
    }

    if (seconds == null || seconds < 0 || seconds >= 60) {
      return 'Seconds must be between 0 and 59.';
    }

    if (minutes == 0 && seconds == 0) {
      return 'Time must be longer than 0 seconds.';
    }

    return null;
  }

  void _saveSession() {
    final distance = double.tryParse(_distanceController.text.trim());
    final minutes = int.tryParse(_minutesController.text.trim());
    final seconds = int.tryParse(_secondsController.text.trim());
    final validationMessage = _validateSession(distance, minutes, seconds);

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    final safeMinutes = minutes!;
    final safeSeconds = seconds!;
    final trimmedPreMeal = _preMealController.text.trim();
    final trimmedPostMeal = _postMealController.text.trim();
    final time = safeMinutes * 60 + safeSeconds;

    final session = Session(
      distance: distance!,
      timeInSeconds: time,
      stroke: _stroke,
      intensity: _intensity,
      date: DateTime.now(),
      preWorkoutMeal: trimmedPreMeal.isEmpty ? null : trimmedPreMeal,
      postWorkoutMeal: trimmedPostMeal.isEmpty ? null : trimmedPostMeal,
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Distance (m)',
                hintText: 'Example: 1500',
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
                      hintText: 'Example: 32',
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
                      hintText: '0-59',
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
