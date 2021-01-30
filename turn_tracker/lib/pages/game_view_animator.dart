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
  AnimationController _repeatController;
  AnimationController _bgController;
  AnimationController _bgRepeatController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    );

    _repeatController = AnimationController(
        duration: const Duration(seconds: 15),
        vsync: this
    );

    _bgController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this
    );

    _bgRepeatController = AnimationController(
        duration: const Duration(seconds: 100),
        vsync: this
    );
  }

  /// Stp repeating spin animation and play starting animation once.
  Future<void> _playSpin() async {
    try {
      _repeatController.stop();
      _bgRepeatController.stop();
      _controller.reset();
      _controller.forward().orCancel;

      _bgController.reverse();
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of.
    }
  }

  /// Play starting animation and then start repeating spin animation.
  Future<void> _playAnimation() async {
    try {
      _controller.reset();
      _repeatController.reset();
      _bgController.reset();
      _bgRepeatController.reset();

      _repeatController.repeat();
      _bgRepeatController.repeat();

      _controller.forward().orCancel;
      _bgController.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of.
    }
  }

  /// Stop repeating animation.
  Future<void> _stopAnimation() async {
    try {
      _repeatController.stop();
      _bgRepeatController.stop();

      await _bgController.reverse().orCancel;
      //_bgController.reset();

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
        repeatController: _repeatController.view,
        bgController: _bgController,
        bgRepeatController: _bgRepeatController,
      ),
    );
  }
}


/// Custom animation sequence for ready button click.
///
/// The button shrinks for a moment and makes one fast rotation.
/// After that it continues repeating a slow linear rotation.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key,
    this.controller, this.repeatController,
    this.bgController, this.bgRepeatController }) :

        // Size of the background graphic increases.
        bgSize = Tween<double>(begin: 160.0, end: 400.0,).animate(
          CurvedAnimation(
            parent: bgController,
            curve: Curves.linear,
            ),
        ),

        // Very slow linear spin for background graphic.
        bgRepeatRotation = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: bgRepeatController,
            curve: Curves.linear,
          ),
        ),

        // Sequence: size of the button shrinks and grows back.
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

        // Fast bouncy spin for button click.
        rotation = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0, 1.00,
              curve: Curves.easeOutCirc,
            ),
          ),
        ),

        // Slow linear spin for button in ready state.
        repeatRotation = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: repeatController,
            curve: Curves.linear,
          ),
        ),

        super(key: key);

  // Values for button animations.
  final AnimationController controller;
  final AnimationController repeatController;
  final Animation<double> size;
  final Animation<double> rotation;
  final Animation<double> repeatRotation;

  // Values for background animations.
  final AnimationController bgController;
  final AnimationController bgRepeatController;
  final Animation<double> bgSize;
  final Animation<double> bgRepeatRotation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: RotationTransition(
            turns: bgRepeatRotation,
            child: Opacity(
              opacity: 0.50,
              child: AnimatedBuilder(
                animation: bgController,
                builder: (context, child) {
                  return Image(
                    width: bgSize.value,
                    height: bgSize.value,
                    image: AssetImage('1024_big.png'),
                  );
                }
              ),
            ),
          ),
        ),
        RotationTransition(
          turns: rotation,
          child: RotationTransition(
            turns: repeatRotation,
            child: Container(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Container(
                    width: size.value,
                    height: size.value,
                    child: Image(
                      width: 160,
                      image: AssetImage('1024.png'),
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ],
    );
  }
}



