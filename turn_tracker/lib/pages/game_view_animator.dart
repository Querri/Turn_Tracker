import 'package:flutter/material.dart';


class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isAnimated}) : super(key: key);
  final bool isAnimated;

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

  Future<void> _playAnimation() async {
    try {
      _controller.reset();
      await _controller.forward().orCancel;
      //_repeatedController.repeat();
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of.
    }
  }

  Future<void> _stopAnimation() async {
    try {
      _controller.stop();
    } on TickerCanceled {
      // animation disposed
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isAnimated) {
      _playAnimation();
    }

    return Center(
      child: StaggerAnimation(
        controller: _controller.view,
        repeatController: _repeatedController.view,
      ),
    );
  }
}


/// Custom animation.
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller, this.repeatController }) :

        opacity = Tween<double>(begin: 0.0, end: 1.0,).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0, 0.100,
              curve: Curves.ease,
            ),
          ),
        ),

        width = TweenSequence(
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
            curve: Curves.easeOutCirc,
          ),
        ),

        super(key: key);

  final AnimationController controller;
  final AnimationController repeatController;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> rotation;
  final Animation<double> repeatRotation;


  Widget _buildAnimation(BuildContext context, Widget child) {
    return RotationTransition(
      turns: repeatRotation,
      child: RotationTransition(
        turns: rotation,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            width: width.value,
            height: width.value,
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


/*
/// Custom animated ready button.
///
/// The button spins slowly when its state is active.
class AnimatedReady extends StatefulWidget {
  AnimatedReady({Key key, this.isAnimated}) : super(key: key);

  final bool isAnimated;

  @override
  _AnimatedReadyState createState() => _AnimatedReadyState();
}

class _AnimatedReadyState extends State<AnimatedReady>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      // starting spin
      _controller.duration = Duration(milliseconds: 500);
      await _controller.forward();

      // repeating spin
      _controller.duration = Duration(seconds: 10);
      await _controller.repeat();
    } on TickerCanceled {
      // animation disposed
    }
  }

  Future<void> _stopAnimation() async {
    try {
      _controller.stop();
    } on TickerCanceled {
      // animation disposed
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isAnimated) {
      _playAnimation();
    } else {
      _stopAnimation();
    }

    return Center(
      child: Container(
        width: 300.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          border: Border.all(
            color:  Colors.black.withOpacity(0.5),
          ),
        ),
        child: StaggerAnimation(
            controller: _controller.view
        ),
      ),
    );

    return RotationTransition(
      turns: _animation,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        //child: StaggerAnimation(controller: _controller),
        child: Image(
          width: 160,
          image: AssetImage('button.png'),
        ),
      ),
    );
  }
}


/// baa
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller }) :

        animation1 = new Tween(begin: 0.5, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.500,
              curve: Curves.easeIn,
            ),
          ),
        ),

        animation2 = new Tween(begin: 0.5, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.500,
              curve: Curves.linear,
            ),
          ),
        ),

        super(key: key);

  final AnimationController controller;
  final AnimationController animation1;
  final Animation<double> animation2;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      width: animation2.value,
      height: animation2.value,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.indigo[300],
          width: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('baa');
  }
}



/// New animation for ready button.
class ReadyAnimation extends StatefulWidget {
  @override
  _ReadyAnimationState createState() => _ReadyAnimationState();
}

class _ReadyAnimationState extends State<ReadyAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/


