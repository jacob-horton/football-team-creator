import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Remove this class
class Navigation {
  static Future<T?> navigateTo<T extends Widget>(BuildContext context, T page) {
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
  }

  static pop(BuildContext context, {Object? result}) {
    Navigator.of(context).pop(result);
  }
}