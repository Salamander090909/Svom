import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/session.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  static const _pageBackground = Color(0xFFF7FAFC);
  static const _cardBackground = Colors.white;
  static const _textPrimary = Color(0xFF0F172A);
  static const _textSecondary = Color(0xFF64748B);
  static const _borderColor = Color(0xFFE2E8F0);

  String _selectedStroke = 'All';

  double calculatePace(double distance, int time) {
    return time / (distance / 100);
  }

  String formatPace(double pace) {
    final minutes = pace ~/ 60;
    final seconds = (pace % 60).toInt();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Session>('sessions');

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        elevation: 0,
        title: const Text(
          "Statistics",
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Session> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No data yet",
                style: TextStyle(color: _textSecondary),
              ),
            );
          }

          final sessions = box.values.where((s) {
            if (_selectedStroke == 'All') return true;
            return s.stroke == _selectedStroke;
          }).toList();

          if (sessions.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _borderColor),
                ),
                child: const Text(
                  "No sessions for this stroke yet",
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          sessions.sort((a, b) => a.date.compareTo(b.date));

          final paces =
              sessions.map((s) => calculatePace(s.distance, s.timeInSeconds)).toList();

          final bestPace = paces.reduce((a, b) => a < b ? a : b);
          final worstPace = paces.reduce((a, b) => a > b ? a : b);

          final totalDistance = sessions.fold<double>(0, (sum, s) => sum + s.distance);
          final avgPace = paces.reduce((a, b) => a + b) / paces.length;

          final spots = List.generate(
            sessions.length,
            (index) => FlSpot(index.toDouble(), paces[index]),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _borderColor),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStroke,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(18),
                    dropdownColor: _cardBackground,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    items: [
                      'All',
                      'Freestyle',
                      'Breaststroke',
                      'Backstroke',
                      'Butterfly',
                    ]
                        .map(
                          (stroke) => DropdownMenuItem(
                            value: stroke,
                            child: Text(stroke),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStroke = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF60A5FA),
                        Color(0xFF38BDF8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Sessions: ${sessions.length}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Total: ${totalDistance.toStringAsFixed(0)} m",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Avg: ${formatPace(avgPace)} /100m",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Best: ${formatPace(bestPace)} /100m",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Pace Progress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Track how your pace changes from session to session.",
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: LineChart(
                    LineChartData(
                      minY: bestPace,
                      maxY: worstPace,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: _borderColor,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0EA5E9),
                              Color(0xFF2563EB),
                            ],
                          ),
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF38BDF8).withOpacity(0.3),
                                const Color(0xFF2563EB).withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map(
                              (spot) {
                                return LineTooltipItem(
                                  "${formatPace(spot.y)} /100m",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
