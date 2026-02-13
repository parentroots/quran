import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final double? borderRadius;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const AppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.borderRadius,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      decoration: decoration ??
          (color != null || borderRadius != null
              ? BoxDecoration(
                  color: color,
                  borderRadius: borderRadius != null
                      ? BorderRadius.circular(borderRadius!)
                      : null,
                )
              : null),
      child: child,
    );
  }
}
