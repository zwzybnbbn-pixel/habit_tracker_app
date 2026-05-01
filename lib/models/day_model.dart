// models/day_model.dart
class DayModel {
  final int dayNumber;
  bool isCompleted;
  DateTime? completedAt;
  String? note; // ملاحظة لهذا اليوم
  
  DayModel({
    required this.dayNumber,
    this.isCompleted = false,
    this.completedAt,
    this.note,
  });
}