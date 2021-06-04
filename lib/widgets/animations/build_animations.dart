///This file contains animations that run during when a widget is being built
import 'package:flutter/material.dart';

class FadeInBuild extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeInBuild({required this.child, this.duration = const Duration(seconds: 1)});

  @override
  _FadeInBuildState createState() => _FadeInBuildState();
}

class _FadeInBuildState extends State<FadeInBuild> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: this.widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _FadeInAnimation(_animation, child: this.widget.child);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _FadeInAnimation extends AnimatedWidget {
  static Tween<double> _opacity = Tween<double>(begin: 0, end: 1);
  final Widget child;

  _FadeInAnimation(Animation<double> animation, {required this.child}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: this.child,
    );
  }
}