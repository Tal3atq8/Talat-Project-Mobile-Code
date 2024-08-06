import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:talat/src/models/label_model.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';

class ChangeLanguageController extends GetxController {
  var value2 = 0;
  RxString laguagecode = "1".obs;

  void setOrderType(String type) {
    laguagecode.value = type;
    print("The order type is ${laguagecode.value}");
    update();
  }

  RxBool isEnglishselected = true.obs;
  final label = LabelModel().obs;

  @override
  void onInit() {
    super.onInit();

    getLabels();
    update();
  }

  getLabels() async {
    laguagecode.value =
        await SharedPref.getString(PreferenceConstants.laguagecode) ?? "1";
  }
}
