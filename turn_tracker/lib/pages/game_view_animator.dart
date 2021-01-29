import 'package:flutter/material.dart';


/// Custom animations for ready button.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.animateBoth, this.isAnimated}) : super(key: key);
  final bool isAnimated;
  final bool animateBoth;

  @override
  _AnimatedReadyState createState() => _AnimatedReadyState();
}

class _AnimatedReadyState extends State<AnimatedReady> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _repeatedController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    );

    _repeatedController = AnimationController(
        duration: const Duration(seconds: 20),
        vsync: this
    );
  }

  /// Stp repeating spin animation and play starting animation once.
  Future<void> _playSpin() async {
    try {
      _repeatedController.stop();
      _controller.reset();
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of.
    }
  }

  /// Play starting animation and then start repeating spin animation.
  Future<void> _playAnimation() async {
    try {
      _controller.reset();
      _repeatedController.reset();
      _repeatedController.repeat();
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of.
    }
  }

  /// Stop repeating animation.
  Future<void> _stopAnimation() async {
    try {
      _repeatedController.stop();
    } on TickerCanceled {
      // animation disposed
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.animateBoth) {
      _playSpin();
    }
    else if (widget.isAnimated) {
      _playAnimation();
    } else {
      _stopAnimation();
    }

    return Center(
      child: StaggerAnimation(
        controller: _controller.view,
        repeatController: _repeatedController.view,
      ),
    );
  }
}


/// Custom animation sequence for ready button click.
///
/// The button shrinks for a moment and makes one fast rotation.
/// After that it continues repeating a slow linear rotation.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller, this.repeatController }) :

        size = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 160.0, end: 140.0)
                  .chain(CurveTween(curve: Curves.elasticOut)),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: 140.0, end: 160.0)
                  .chain(CurveTween(curve: Curves.ease)),
              weight: 50.0,
            ),
          ],
        ).animate(
            (CurvedAnimation(parent: controller, curve: Interval(0.0, 0.8)))),

        rotation = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0, 1.00,
              curve: Curves.easeOutCirc,
            ),
          ),
        ),

        repeatRotation = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: repeatController,
            curve: Curves.linear,
          ),
        ),

        super(key: key);

  final AnimationController controller;
  final AnimationController repeatController;
  final Animation<double> size;
  final Animation<double> rotation;
  final Animation<double> repeatRotation;


  Widget _buildAnimation(BuildContext context, Widget child) {
    return RotationTransition(
      turns: rotation,
      child: RotationTransition(
        turns: repeatRotation,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            width: size.value,
            height: size.value,
            child: Image(
              width: 160,
              image: AssetImage('button.png'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}



