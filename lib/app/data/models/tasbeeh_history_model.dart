import 'package:hive/hive.dart';

part 'tasbeeh_history_model.g.dart';

@HiveType(typeId: 4)
class TasbeehHistory extends HiveObject {
  @HiveField(0)
  final String dhikr;

  @HiveField(1)
  final int count;

  @HiveField(2)
  final DateTime date;

  TasbeehHistory({
    required this.dhikr,
    required this.count,
    required this.date,
  });
}
