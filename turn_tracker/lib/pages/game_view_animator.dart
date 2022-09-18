import 'package:flutter/material.dart';


/// Custom animations for ready button.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isReady, this.shouldAnimateReady,
    this.buttonSize, this.useCroppedImage}) : super(key: key);
  final bool isReady;
  final bool shouldAnimateReady;
  final double buttonSize;
  final bool useCroppedImage;

  @override
  _AnimatedReadyState createState() => _AnimatedReadyState();
}

class _AnimatedReadyState extends State<AnimatedReady> with TickerProviderStateMixin {
  AnimationController _controller;
  AssetImage readyImage;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isReady) {
      if (widget.useCroppedImage) {
        readyImage = AssetImage('1024_ready_inactive_cropped.png');
      } else {
        readyImage = AssetImage('1024_ready_inactive.png');
      }
      if (widget.shouldAnimateReady) {
        _controller.reset();
        _controller.forward().orCancel;
      }
    } else {
      //TODO check when toggled
      if (widget.useCroppedImage) {
        readyImage = AssetImage('1024_ready_active_cropped.png');
      } else {
        readyImage = AssetImage('1024_ready_active.png');
      }
      _controller.reset();
      _controller.reverse().orCancel;
    }

    return Center(
      child: StaggerAnimation(
        controller: _controller.view,
        buttonSize: widget.buttonSize,
        buttonImage: readyImage,
      ),
    );
  }
}


/// Custom animation sequence for ready button click.
///
/// The button changes size and color.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller, this.buttonSize, this.buttonImage }) :

  // Sequence: size of the button shrinks and grows back.
        animatedSize = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize, end: buttonSize*0.5)
                  .chain(CurveTween(curve: Curves.easeOutQuart)),
              weight: 30.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: buttonSize*0.5, end: buttonSize*0.6)
                  .chain(CurveTween(curve: Curves.easeInOutBack)),
              weight: 70.0,
            ),
          ],
        ).animate((CurvedAnimation(parent: controller, curve: Interval(0.0, 0.3)))),

        super(key: key);

  final AnimationController controller;
  final Animation<double> animatedSize;
  final double buttonSize;
  final AssetImage buttonImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Image(
              width: animatedSize.value,
              height: animatedSize.value,
              image: buttonImage,
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
