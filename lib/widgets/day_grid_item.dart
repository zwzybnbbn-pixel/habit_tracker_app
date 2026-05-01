// widgets/day_grid_item.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/utils/constants.dart';

class DayGridItem extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final bool isToday;
  final Color habitColor;
  final VoidCallback onTap;
  
  const DayGridItem({
    super.key,
    required this.dayNumber,
    required this.isCompleted,
    required this.isToday,
    required this.habitColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isCompleted
              ? habitColor
              : isToday
                  ? habitColor.withOpacity(0.1)
                  : AppColors.incomplete.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: habitColor, width: 2)
              : null,
          boxShadow: [
            if (isCompleted)
              BoxShadow(
                color: habitColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Center(
          child: Text(
            dayNumber.toString(),
            style: TextStyle(
              color: isCompleted
                  ? Colors.white
                  : isToday
                      ? habitColor
                      : Colors.grey.shade600,
              fontWeight: isCompleted || isToday
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}