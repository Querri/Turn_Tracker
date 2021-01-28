import 'package:flutter/material.dart';


/// Custom animated ready button.
///
/// The button spins slowly when its state is active.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isAnimated, this.curve}) : super(key: key);

  final bool isAnimated;
  final String curve;

  @override
  _AnimatedReadyState createState() => _AnimatedReadyState();
}

class _AnimatedReadyState extends State<AnimatedReady>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    Curve curve = Curves.linear;

    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> playAnimation() async {
    try {
      await _controller.forward();
      await _controller.reverse();
    } on TickerCanceled {
      // animation disposed
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isAnimated) {
      _controller.repeat();
    } else {
      _controller.stop();
    }

    return RotationTransition(
      turns: _animation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Image(
          width: 160,
          image: AssetImage('button.png'),
        ),
      ),
    );
  }
}