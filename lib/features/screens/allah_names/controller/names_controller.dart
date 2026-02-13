import 'package:get/get.dart';
import '../data/names_model.dart';
import '../data/names_data.dart';

class NamesController extends GetxController {
  final List<IslamicName> names = NamesData.names;
}
