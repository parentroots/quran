import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/utils/constant/app_colors.dart';
import '../controller/qibla_controller.dart';
import '../../../../utils/constant/app_strings.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';
import '../widget/error_banner.dart';

class QiblaView extends StatefulWidget {
  const QiblaView({super.key});

  @override
  State<QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<QiblaView> {
  late final QiblaController controller;

  @override
  void initState() {
    super.initState();
    controller = QiblaController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Premium Dark Blue
      body: Obx(() {
        if (!controller.hasPermission.value) {
          return _buildPermissionRequest();
        }

        if (controller.isLoading.value &&
            controller.userLatitude.value == 0.0) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC29C5A)));
        }

        return AppContainer(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [
                Color(0xFF1E293B),
                Color(0xFF0F172A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  title: AppString.qiblaTitle,
                  subtitle: Obx(() => AppText(
                        _getHeadingDirection(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      )),
                  actions: [
                    IconButton(
                      onPressed: () => controller.refreshLocation(),
                      icon: const Icon(Icons.my_location,
                          color: Color(0xFFC29C5A)),
                    ),
                  ],
                ),

                if (controller.errorMessage.isNotEmpty) buildErrorBanner(controller),

                const Spacer(),

                /// Compass and Qibla Indicator
                _buildCompass(context),

                const Spacer(),

                /// Location Details and Actions
                _buildBottomDetails(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_outlined,
                color: Colors.redAccent, size: 80),
            const SizedBox(height: 24),
            const AppText(
              AppString.locationPermissionNeeded,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const AppText(
              AppString.qiblaLocationDesc,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => controller.checkPermissions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC29C5A),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const AppText(AppString.givePermission,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCompass(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// Fixed Outer Marker (Indicator for North relative to user device)
        Positioned(
          top: -10,
          child: AppContainer(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFC29C5A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        /// Compass Dial (Rotates to stay aligned with North)
        AnimatedRotation(
          turns: -controller.compassHeading.value / 360,
          duration: const Duration(milliseconds: 200),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Main Compass Disc
              AppContainer(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
              ),

              /// Cardinal Points
              for (int i = 0; i < 4; i++)
                _buildCardinalPoint(
                    i == 0
                        ? "N"
                        : i == 1
                            ? "E"
                            : i == 2
                                ? "S"
                                : "W",
                    i * 90),

              /// Minute/Degree markers
              for (int i = 0; i < 72; i++)
                if (i % 18 != 0) // Skip cardinal positions
                  _buildDegreeMarker(i * 5),

              /// Qibla Indicator Group (Kaaba side)
              AnimatedRotation(
                turns: controller.qiblaDirection.value / 360,
                duration: const Duration(milliseconds: 300),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),

                          /// Kaaba Icon Representation
                          AppContainer(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const AppText(
                              "🕋",
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Needle to Kaaba
                    AppContainer(
                      margin: const EdgeInsets.only(top: 40),
                      width: 2,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFC29C5A),
                            const Color(0xFFC29C5A).withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Central Core
        AppContainer(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1E293B),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  "${(controller.compassHeading.value.toInt() + 360) % 360}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppText(
                  _getHeadingDirection(),
                  style: const TextStyle(
                    color: Color(0xFFC29C5A),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardinalPoint(String label, double angle) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: AppContainer(
        height: 300,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 10),
        child: AppText(
          label,
          style: TextStyle(
            color: label == "N" ? Colors.redAccent : Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDegreeMarker(double angle) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: AppContainer(
        height: 280,
        alignment: Alignment.topCenter,
        child: AppContainer(
          width: angle % 10 == 0 ? 2 : 1,
          height: angle % 10 == 0 ? 10 : 6,
          color: Colors.white24,
        ),
      ),
    );
  }

  Widget _buildBottomDetails(BuildContext context) {
    final isAligned = controller.isQiblaAligned;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          /// Status Message
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isAligned
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isAligned
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAligned ? Icons.check_circle : Icons.info_outline,
                  color: isAligned ? Colors.greenAccent : Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                AppText(
                  isAligned
                      ? AppString.alignedWithQibla
                      : AppString.turnPhoneToQibla,
                  style: TextStyle(
                    color: isAligned ? Colors.greenAccent : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// Coordinates Card
          AppContainer(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                _buildCoordinateItem(AppString.latitude, controller.latString),
                AppContainer(width: 1, height: 40, color: Colors.white12),
                _buildCoordinateItem(AppString.longitude, controller.lngString),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          AppText(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 4),
          AppText(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _getHeadingDirection() {
    double heading = (controller.compassHeading.value + 360) % 360;
    if (heading >= 337.5 || heading < 22.5) return "North";
    if (heading >= 22.5 && heading < 67.5) return "Northeast";
    if (heading >= 67.5 && heading < 112.5) return "East";
    if (heading >= 112.5 && heading < 157.5) return "Southeast";
    if (heading >= 157.5 && heading < 202.5) return "South";
    if (heading >= 202.5 && heading < 247.5) return "Southwest";
    if (heading >= 247.5 && heading < 292.5) return "West";
    if (heading >= 292.5 && heading < 337.5) return "Northwest";
    return "";
  }
}
