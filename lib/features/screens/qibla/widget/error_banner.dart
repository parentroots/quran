import 'package:flutter/material.dart';
import 'package:islamic_app/features/screens/qibla/controller/qibla_controller.dart';

import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';

Widget buildErrorBanner(QiblaController controller) {
  return AppContainer(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.redAccent.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}