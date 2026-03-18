import 'dart:math';
import 'package:flutter/material.dart';

class FloatingFoodIcon extends StatefulWidget {
  final IconData icon;
  const FloatingFoodIcon({super.key, required this.icon});

  @override
  State<FloatingFoodIcon> createState() => _FloatingFoodIconState();
}

class _FloatingFoodIconState extends State<FloatingFoodIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _randomLeft;
  late double _randomSize;
  late double _randomStartOffset;

  @override
  void initState() {
    super.initState();
    _randomLeft = Random().nextDouble();
    _randomSize = Random().nextDouble() * 25 + 15;
    // This creates a random starting point so they aren't in a perfect line
    _randomStartOffset = Random().nextDouble(); 

    _controller = AnimationController(
      duration: Duration(seconds: 15 + Random().nextInt(10)),
      vsync: this,
    );

    // Start from a random position in the loop
    _controller.forward(from: _randomStartOffset);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final height = MediaQuery.of(context).size.height;
        // Calculation to ensure they start off-screen and end off-screen
        double currentY = (height + 150) * (1 - _controller.value) - 100;

        return Positioned(
          bottom: currentY,
          left: MediaQuery.of(context).size.width * _randomLeft,
          child: Transform.rotate(
            angle: _controller.value * 2 * pi, // Adds the spin!
            child: Opacity(
              opacity: 0.12,
              child: Icon(widget.icon, size: _randomSize, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}