import 'package:flutter/material.dart';


/// Custom animations for ready button.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isReady, this.shouldAnimateReady}) : super(key: key);
  final bool isReady;
  final bool shouldAnimateReady;

  @override
  _AnimatedReadyState createState() => _AnimatedReadyState();
}

class _AnimatedReadyState extends State<AnimatedReady> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _repeatController;

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
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isReady) {
      _repeatController.repeat();
      if (widget.shouldAnimateReady) {
        _controller.reset();
        _controller.forward().orCancel;
      }
    } else {
      _repeatController.stop();
      if (widget.shouldAnimateReady) {
        _controller.reset();
        _controller.forward().orCancel;
      }
    }

    return Center(
      child: StaggerAnimation(
        controller: _controller.view,
        repeatController: _repeatController.view,
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

  final AnimationController controller;
  final AnimationController repeatController;
  final Animation<double> size;
  final Animation<double> rotation;
  final Animation<double> repeatRotation;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
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
    );
  }
}


/// Custom animations for ready background.
class AnimatedBg extends StatefulWidget {
  AnimatedBg({Key key, this.isReady, this.shouldAnimateReady}) : super(key: key);
  final bool isReady;
  final bool shouldAnimateReady;

  @override
  _AnimatedBgState createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg> with TickerProviderStateMixin {
  AnimationController _bgController;
  AnimationController _bgRepeatController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this
    );

    _bgRepeatController = AnimationController(
        duration: const Duration(seconds: 100),
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isReady) {
      _bgRepeatController.repeat();
      if (widget.shouldAnimateReady) {
        _bgController.forward().orCancel;
      }
    } else {
      _bgController.reverse().orCancel;
      _bgRepeatController.stop();
    }

    return Center(
      child: BgStaggerAnimation(
        bgController: _bgController,
        bgRepeatController: _bgRepeatController,
      ),
    );
  }
}


/// Custom animation sequence for animated background when player is ready.
///
/// The background graphic grows and then repeats a slow rotation as
/// long as the player is ready.
class BgStaggerAnimation extends StatelessWidget {
  BgStaggerAnimation({ Key key, this.bgController, this.bgRepeatController }) :

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

        super(key: key);

  // Values for background animations.
  final AnimationController bgController;
  final AnimationController bgRepeatController;
  final Animation<double> bgSize;
  final Animation<double> bgRepeatRotation;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}



