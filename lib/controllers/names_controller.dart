import 'package:get/get.dart';
import '../core/models/names_model.dart';
import '../services/providers/names_data.dart';

class NamesController extends GetxController {
  final List<IslamicName> names = NamesData.names;
}
