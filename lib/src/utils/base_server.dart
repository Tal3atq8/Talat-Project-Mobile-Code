import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/theme/constant_strings.dart';

Future<void> showBaseUrlDialog(BuildContext context) async {
  final TextEditingController baseUrlController = TextEditingController(text: ConstantStrings.baseUrl);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must enter URL
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Base URL'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(hintText: "Enter Base URL"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              if (baseUrlController.text.isNotEmpty) {
                ConstantStrings.updateBaseUrl(baseUrlController.text);
                Get.back();
                print("New Base URL: ${ConstantStrings.baseUrl}");
              }
            },
          ),
        ],
      );
    },
  );
}
