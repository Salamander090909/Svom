import 'package:hive/hive.dart';

part 'session.g.dart';

@HiveType(typeId: 0)
class Session extends HiveObject {
  @HiveField(0)
  double distance;

  @HiveField(1)
  int timeInSeconds;

  @HiveField(2)
  String stroke;

  @HiveField(3)
  String intensity;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? preWorkoutMeal;

  @HiveField(6)
  String? postWorkoutMeal;

  @HiveField(7)
  int? energyLevel;

  Session({
    required this.distance,
    required this.timeInSeconds,
    required this.stroke,
    required this.intensity,
    required this.date,
    this.preWorkoutMeal,
    this.postWorkoutMeal,
    this.energyLevel,
  });
}