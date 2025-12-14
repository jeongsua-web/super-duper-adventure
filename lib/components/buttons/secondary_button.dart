import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 45,
      child: OutlinedButton(
        onPressed: (enabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? const Color(0xFF4DDBFF),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    borderColor ?? const Color(0xFF4DDBFF),
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? const Color(0xFF4DDBFF),
                  fontSize: fontSize ?? 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
