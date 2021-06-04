import 'package:flutter/material.dart';

abstract class OverlaySkeleton {
  void markNeedsBuild();

  void show(BuildContext context);

  void remove(BuildContext context);

  void dispose();

  bool mounted();

  bool get needsDispose;
}
