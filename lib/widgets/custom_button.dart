// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;  // ✅ هنا VoidCallback? (علامة استفهام)
  final IconData? icon;
  final bool isOutlined;
  final bool isLoading;
  final Color? color;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,  // ✅ هذا optional (علامة استفهام في التعريف)
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = color ?? AppColors.primary;

    return Container(
      width: width ?? double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isOutlined ? null : LinearGradient(
          colors: [buttonColor, buttonColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: isOutlined ? Border.all(color: buttonColor, width: 2) : null,
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,  // ✅ هنا onTap (ليس onPressed)
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: isOutlined ? buttonColor : Colors.white,
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isOutlined ? buttonColor : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: isOutlined ? buttonColor : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}