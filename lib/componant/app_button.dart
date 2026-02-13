import 'package:flutter/material.dart';

enum ButtonType { elevated, text, outlined }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(text),
            ],
          )
        : Text(text);

    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      shape: borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            )
          : null,
    );

    Widget button;
    switch (type) {
      case ButtonType.elevated:
        button = ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding,
            shape: borderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  )
                : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: backgroundColor != null
                ? BorderSide(color: backgroundColor!)
                : null,
            padding: padding,
            shape: borderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  )
                : null,
          ),
          child: buttonChild,
        );
        break;
    }

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}
