import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class WindowResize {
  static const _aspect = 0.725;

  static void setSize(Size size, {bool? fixedSize}) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      DesktopWindow.setWindowSize(size);

      if (fixedSize != null && fixedSize) {
        setWindowMaxSize(size);
        setWindowMinSize(size);
      }
    }
  }

  static void setWidthMaintainAspect(double width, {bool? fixedSize}) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      Size size = Size(width, width * _aspect);
      DesktopWindow.setWindowSize(size);
      
      if (fixedSize != null && fixedSize) {
        setWindowMaxSize(size);
        setWindowMinSize(size);
      }
    }
  }
}
