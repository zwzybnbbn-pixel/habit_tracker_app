// widgets/progress_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/utils/constants.dart';

class ProgressChart extends StatelessWidget {
  final Habit habit;

  const ProgressChart({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    Color habitColor = Color(int.parse('0xFF${habit.color}'));

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppShadows.soft],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: habitColor,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${(rod.toY * 100).toStringAsFixed(0)}%',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('الأسبوع ١');
                  if (value == 1) return const Text('الأسبوع ٢');
                  if (value == 2) return const Text('الأسبوع ٣');
                  if (value == 3) return const Text('الأسبوع ٤');
                  return const Text('');
                },
                reservedSize: 32,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${(value * 100).toStringAsFixed(0)}%');
                },
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<double> weeklyProgress = [0, 0, 0, 0];

    for (int day = 1; day <= 30; day++) {
      int weekIndex = (day - 1) ~/ 7;
      if (weekIndex < 4) {
        if (habit.completedDays[day] == true) {
          weeklyProgress[weekIndex] += 1 / 7;
        }
      }
    }

    for (int i = 0; i < 4; i++) {
      weeklyProgress[i] = weeklyProgress[i].clamp(0.0, 1.0);
    }

    Color habitColor = Color(int.parse('0xFF${habit.color}'));

    return List.generate(4, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyProgress[index],
            color: habitColor,
            width: 22,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 1,
              color: habitColor.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }
}