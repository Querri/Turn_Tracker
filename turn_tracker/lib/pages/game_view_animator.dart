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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isReady) {
      if (widget.shouldAnimateReady) {
        _controller.reset();
        _controller.forward().orCancel;
      }
    } else {
      //TODO check when toggle
      _controller.reset();
      _controller.reverse().orCancel;
    }

    /*
    return Center(
      child: StaggerAnimation2(
        controller: _controller.view,
        buttonSize: widget.buttonSize,
      ),
    );
    */

    return Center(
      child: StaggerAnimation(
        controller: _controller.view,
        buttonSize: widget.buttonSize,
      ),
    );
  }
}


/// Custom animation sequence for ready button click.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller, this.buttonSize }) :

  // Sequence: size of the button shrinks and grows back.
        size = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize, end: buttonSize*0.8)
                  .chain(CurveTween(curve: Curves.easeOutQuart)),
              weight: 30.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize*0.8, end: buttonSize*1.4)
                  .chain(CurveTween(curve: Curves.easeInOutBack)),
              weight: 70.0,
            ),
          ],
        ).animate((CurvedAnimation(parent: controller, curve: Interval(0.0, 0.3)))),

        super(key: key);

  final AnimationController controller;
  final Animation<double> size;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}



/*
/// Custom animation sequence for ready button click.
///
/// The button shrinks for a moment and makes one fast rotation.
/// After that it continues repeating a slow linear rotation.
class StaggerAnimation2 extends StatelessWidget {
  StaggerAnimation2({ Key key, this.controller, this.buttonSize }) :

      // Sequence: size of the button shrinks and grows back.
      size = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween(begin: buttonSize, end: buttonSize*0.8)
                .chain(CurveTween(curve: Curves.easeOutQuart)),
            weight: 30.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween(begin: buttonSize*0.8, end: buttonSize*1.4)
                .chain(CurveTween(curve: Curves.easeInOutBack)),
            weight: 70.0,
          ),
        ],
      ).animate((CurvedAnimation(parent: controller, curve: Interval(0.0, 0.3)))),

        super(key: key);

  final AnimationController controller;
  final Animation<double> size;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
 */
