///This file contains animations that run during when a widget is being built
import 'package:flutter/material.dart';

class FadeInBuild extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double startingOpacity;

  FadeInBuild({required this.child, this.duration = const Duration(seconds: 1), this.startingOpacity = 0})
      : assert(
  startingOpacity >= 0 && startingOpacity <= 1, 'Given starting opacity did not fit the Opacity widgets constraints!');

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
    return _FadeInAnimation(_animation, child: this.widget.child, startingOpacity: this.widget.startingOpacity,);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _FadeInAnimation extends AnimatedWidget {
  final Tween<double> _opacity;
  final Widget child;
  final double startingOpacity;

  _FadeInAnimation(Animation<double> animation, {required this.child, required this.startingOpacity})
      : _opacity = Tween<double>(begin: startingOpacity, end: 1),
        super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: this.child,
    );
  }
}
