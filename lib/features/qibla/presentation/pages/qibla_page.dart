import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../controllers/qibla_controller.dart';
import '../../../../core/config/theme.dart';

class QiblaPage extends GetView<QiblaController> {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        elevation: 0,
      ),
      body: Obx(() {
        if (!controller.isDeviceSupported.value) {
          return _buildErrorState(
            context,
            'Device Not Supported',
            'Your device does not support compass sensors',
          );
        }
        
        if (!controller.hasPermission.value) {
          return _buildPermissionState(context);
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return _buildErrorState(
            context,
            'Error',
            controller.errorMessage.value,
          );
        }
        
        return _buildQiblaCompass(context);
      }),
    );
  }
  
  Widget _buildQiblaCompass(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.1),
            AppTheme.secondaryTeal.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Point your phone towards Kaaba',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            
            // Compass
            Obx(() {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Compass Circle
                  Transform.rotate(
                    angle: -controller.qiblaDirection.value * (math.pi / 180),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryGreen,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // North indicator
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'N',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Compass markings
                          ...List.generate(36, (index) {
                            final angle = index * 10.0;
                            return Transform.rotate(
                              angle: angle * (math.pi / 180),
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 2,
                                  height: index % 3 == 0 ? 20 : 10,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  
                  // Kaaba Icon (Fixed - points to Qibla)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              );
            }),
            
            const SizedBox(height: 60),
            
            // Direction Info
            Obx(() {
              final direction = controller.qiblaDirection.value;
              return Column(
                children: [
                  Text(
                    '${direction.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDirectionText(direction),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPermissionState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.orange.shade300,
            ),
            const SizedBox(height: 24),
            const Text(
              'Location Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'We need your location to determine the Qibla direction accurately.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.requestPermissions,
              icon: const Icon(Icons.location_on),
              label: const Text('Grant Permission'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context, String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getDirectionText(double direction) {
    if (direction >= 337.5 || direction < 22.5) return 'North';
    if (direction >= 22.5 && direction < 67.5) return 'North-East';
    if (direction >= 67.5 && direction < 112.5) return 'East';
    if (direction >= 112.5 && direction < 157.5) return 'South-East';
    if (direction >= 157.5 && direction < 202.5) return 'South';
    if (direction >= 202.5 && direction < 247.5) return 'South-West';
    if (direction >= 247.5 && direction < 292.5) return 'West';
    if (direction >= 292.5 && direction < 337.5) return 'North-West';
    return '';
  }
}
