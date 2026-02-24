import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/session.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
      backgroundColor: const Color(0xFF0F172A), // mørk bakgrunn
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Statistics"),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Session> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No data yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final sessions = box.values.where((s) {
            if (_selectedStroke == 'All') return true;
            return s.stroke == _selectedStroke;
          }).toList();

          sessions.sort((a, b) => a.date.compareTo(b.date));

          final paces = sessions
              .map((s) => calculatePace(s.distance, s.timeInSeconds))
              .toList();

          final bestPace = paces.reduce((a, b) => a < b ? a : b);
          final worstPace = paces.reduce((a, b) => a > b ? a : b);

          final totalDistance = sessions.fold<double>(
              0, (sum, s) => sum + s.distance);

          final avgPace =
              paces.reduce((a, b) => a + b) / paces.length;

          final spots = List.generate(
            sessions.length,
            (index) => FlSpot(
              index.toDouble(),
              paces[index],
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // FILTER
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF1E293B),
                  value: _selectedStroke,
                  style: const TextStyle(color: Colors.white),
                  items: [
                    'All',
                    'Freestyle',
                    'Breaststroke',
                    'Backstroke',
                    'Butterfly'
                  ]
                      .map((stroke) => DropdownMenuItem(
                            value: stroke,
                            child: Text(stroke),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStroke = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // OVERVIEW CARD MED GRADIENT
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF06B6D4),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Overview",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text("Sessions: ${sessions.length}",
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          "Total: ${totalDistance.toStringAsFixed(0)} m",
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          "Avg: ${formatPace(avgPace)} /100m",
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          "Best: ${formatPace(bestPace)} /100m",
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Pace Progress",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                const SizedBox(height: 20),

                Container(
                  height: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius:
                        BorderRadius.circular(24),
                  ),
                  child: LineChart(
                    LineChartData(
                      minY: bestPace,
                      maxY: worstPace,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.05),
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
                              Color(0xFF22D3EE),
                              Color(0xFF6366F1),
                            ],
                          ),
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF22D3EE)
                                    .withOpacity(0.3),
                                const Color(0xFF6366F1)
                                    .withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData:
                            LineTouchTooltipData(
                          getTooltipItems:
                              (touchedSpots) {
                            return touchedSpots.map(
                              (spot) {
                                return LineTooltipItem(
                                  "${formatPace(spot.y)} /100m",
                                  const TextStyle(
                                      color:
                                          Colors.white),
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