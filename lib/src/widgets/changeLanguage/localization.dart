import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/utils/global_constants.dart' as globals;

class WorldLanguage extends Translations {
  Map<String, String> eng = {};
  Map<String, String> ar = {};
  addLabelKeyToModel() {
    for (var element in globals.labelResult) {
      Map<String, String> e = {"${element.key}": "${element.valueEn}"};
      Map<String, String> a = {"${element.key}": "${element.valueAr}"};

      eng.addAll(e);
      ar.addAll(a);
    }

    debugPrint('$eng');
    debugPrint('$ar');
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': eng,

        'ar_AR': ar,

        //add more language here
      };
}
