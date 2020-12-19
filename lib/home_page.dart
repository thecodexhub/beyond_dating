import 'package:beyond_dating/app_colors.dart';
import 'package:beyond_dating/strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final duration = Duration(milliseconds: 750);

  AnimationController _logoAnimationController;
  Animation<double> _logoScaleAnimation;

  AnimationController _textAnimationController;
  Animation<Offset> _nameSlideAnimation, _aboutSlideAnimation;
  Animation<double> _nameOpacityAnimation, _aboutOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _logoAnimationController =
        AnimationController(vsync: this, duration: duration)
          ..addListener(() {
            setState(() {});
          });
    _textAnimationController =
        AnimationController(vsync: this, duration: duration)
          ..addListener(() {
            setState(() {});
          });

    _logoScaleAnimation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 75.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 25.0,
      ),
    ]).animate(_logoAnimationController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textAnimationController.forward();
      }
    });

    _nameSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(parent: _textAnimationController, curve: Interval(0.0, 0.5)));
    _aboutSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(parent: _textAnimationController, curve: Interval(0.5, 1.0)));
    _nameOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: _textAnimationController, curve: Interval(0.0, 0.5)));
    _aboutOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: _textAnimationController, curve: Interval(0.5, 1.0)));

    _logoAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            _buildBackgroundChild(),
            Center(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _buildChildren(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundChild() {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Positioned(
      left: screenWidth - 260.0,
      bottom: screenHeight - 260.0,
      child: Image.asset(
        Strings.backgroundLogo,
        height: 288.0,
        width: 288.0,
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Transform.scale(
        scale: _logoScaleAnimation.value,
        child: Image.asset(
          Strings.appLogo,
          height: 120.0,
          width: 120.0,
        ),
      ),
      // SizedBox(height: 8.0),
      SlideTransition(
        position: _nameSlideAnimation,
        child: Opacity(
          opacity: _nameOpacityAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Beyond',
                style: TextStyle(
                  color: AppColors.lightTextColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Dating',
                style: TextStyle(
                  color: AppColors.lightShadeTextColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 4.0),
      SlideTransition(
        position: _aboutSlideAnimation,
        child: Opacity(
          opacity: _aboutOpacityAnimation.value,
          child: Text(
            Strings.about,
            style: TextStyle(
              color: AppColors.accentColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    ];
  }
}
