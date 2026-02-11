import 'package:get/get.dart';
import '../../../data/models/names_model.dart';
import '../../../data/providers/names_data.dart';

class NamesController extends GetxController {
  final List<IslamicName> names = NamesData.names;
}
