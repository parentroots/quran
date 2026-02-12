import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/qibla_controller.dart';

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
      backgroundColor: const Color(0xFF0F172A), // Premium Dark Blue
      body: Obx(() {
        if (!controller.hasPermission.value) {
          return _buildPermissionRequest();
        }

        if (controller.isLoading.value &&
            controller.userLatitude.value == 0.0) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC29C5A)));
        }

        return Container(
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
                _buildAppBar(context),

                if (controller.errorMessage.isNotEmpty) _buildErrorBanner(),

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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
          ),
          const Text(
            "কিবলা কম্পাস",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            onPressed: () => controller.refreshLocation(),
            icon: const Icon(Icons.my_location, color: Color(0xFFC29C5A)),
          ),
        ],
      ),
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
            const Text(
              "লোকেশন অনুমতি প্রয়োজন",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "কিবলার দিক সঠিকভাবে নির্ণয় করতে আপনার লোকেশন অ্যাক্সেস প্রয়োজন।",
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
              child: const Text("অনুমতি দিন",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
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
          child: Container(
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
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
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
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "🕋",
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Needle to Kaaba
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: 2,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFC29C5A),
                            const Color(0xFFC29C5A).withOpacity(0),
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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1E293B),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(controller.compassHeading.value.toInt() + 360) % 360}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
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
      child: Container(
        height: 300,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 10),
        child: Text(
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
      child: Container(
        height: 280,
        alignment: Alignment.topCenter,
        child: Container(
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
                  ? Colors.green.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isAligned
                    ? Colors.green.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
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
                Text(
                  isAligned
                      ? "কিবলার সঠিক দিকে আছেন"
                      : "ফোনটি কিবলার দিকে ঘুরান",
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                _buildCoordinateItem(
                    "অক্ষরেখা (Latitude)", controller.latString),
                Container(width: 1, height: 40, color: Colors.white12),
                _buildCoordinateItem(
                    "দ্রাঘিমারেখা (Longitude)", controller.lngString),
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
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
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
