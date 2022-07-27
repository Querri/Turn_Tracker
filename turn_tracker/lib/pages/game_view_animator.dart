import 'package:flutter/material.dart';


/// Custom animations for ready button.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isReady, this.shouldAnimateReady, this.buttonSize}) : super(key: key);
  final bool isReady;
  final bool shouldAnimateReady;
  final double buttonSize;

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
        buttonSize: widget.buttonSize,
      ),
    );
  }
}


/// Custom animation sequence for ready button click.
///
/// The button shrinks for a moment and makes one fast rotation.
/// After that it continues repeating a slow linear rotation.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller, this.repeatController, this.buttonSize }) :

        // Sequence: size of the button shrinks and grows back.
        size = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize, end: buttonSize*0.9)
                  .chain(CurveTween(curve: Curves.easeOutQuart)),
              weight: 30.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize*0.9, end: buttonSize)
                  .chain(CurveTween(curve: Curves.easeInOutBack)),
              weight: 70.0,
            ),
          ],
        ).animate(
            (CurvedAnimation(parent: controller, curve: Interval(0.0, 0.5)))),

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
  final double buttonSize;
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
              return Image(
                width: size.value,
                height: size.value,
                image: AssetImage('1024_ready_inactive.png'),
              );
            }
          ),
        ),
      ),
    );
  }
}

