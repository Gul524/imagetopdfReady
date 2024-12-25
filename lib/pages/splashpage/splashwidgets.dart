import 'package:flutter/material.dart';
import 'package:imagetopdf/utils/colors.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _dot1Animation = Tween<double>(begin: 0, end: 7).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2)),
    );
    _dot2Animation = Tween<double>(begin: 0, end: 7).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.4)),
    );
    _dot3Animation = Tween<double>(begin: 0, end: 7).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, .6)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _dot1Animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _dot1Animation.value),
              child: child,
            );
          },
          child: const Dot(),
        ),
        const SizedBox(width: 8),
        AnimatedBuilder(
          animation: _dot2Animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _dot2Animation.value),
              child: child,
            );
          },
          child: const Dot(),
        ),
        const SizedBox(width: 8),
        AnimatedBuilder(
          animation: _dot3Animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _dot3Animation.value),
              child: child,
            );
          },
          child: const Dot(),
        ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.themeColor,
      ),
    );
  }
}
