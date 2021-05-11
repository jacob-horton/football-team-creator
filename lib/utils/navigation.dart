import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation {
  static navigateTo<T extends Widget>(BuildContext context, T page) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}