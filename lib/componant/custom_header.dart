import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_text.dart';
import 'app_container.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final double? height;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                subtitle!,
              ],
            ],
          ),
          if (actions != null)
            Positioned(
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}
