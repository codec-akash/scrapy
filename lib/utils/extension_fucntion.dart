import 'package:flutter/material.dart';

extension BuildContextExtensionFunctions on BuildContext {
  showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }

  getWidthAspectValue(double num) {
    return (MediaQuery.of(this).size.width * num) / 800;
  }

  getHeightAspectValue(double num) {
    return (MediaQuery.of(this).size.height * num) / 1080;
  }
}
