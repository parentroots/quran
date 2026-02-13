import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/splash_controller.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';
import '../../../../utils/constant/app_strings.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final SplashController controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashController());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Modern Dark Navy
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background subtle pattern or gradient
          AppContainer(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Theme.of(context).primaryColor,
                  const Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          // Central Logo and Text
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        // Logo Placeholder (Using an Icon since AI generation is down)
                        AppContainer(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF507EFF).withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF507EFF).withOpacity(0.2),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(child: Image.asset("assets/images/appLogo.png")),
                        ),
                        SizedBox(height: 32.h),
                        const AppText(
                          AppString.appNameBengali,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        const AppText(
                          AppString.islamicLifestyle,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: Color(0xFFC29C5A),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom credit Text
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEFB854)),
                ),
                SizedBox(height: 24.h),
                AppText(
                  AppString.copyright,
                  fontSize: 12.sp,
                  letterSpacing: 0.5,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
