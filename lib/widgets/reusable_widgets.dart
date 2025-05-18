import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Animated scaling button
class AnimatedActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const AnimatedActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = Colors.blue,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Slide + fade in animation for list items
class AnimatedEntrance extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedEntrance({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ),
      duration: Duration(milliseconds: 400 + index * 100),
      builder: (context, offset, _) {
        return Transform.translate(
          offset: offset * 30,
          child: Opacity(
            opacity: 1 - offset.dx,
            child: child,
          ),
        );
      },
    );
  }
}

/// Lottie loading animation widget
class LoadingLottie extends StatelessWidget {
  const LoadingLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/loading.json',
        width: 150,
        height: 150,
      ),
    );
  }
}