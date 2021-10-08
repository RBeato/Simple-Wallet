import 'package:basic_wallet/home_page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../logo.dart';

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[200],
                  Colors.blue[50],
                ],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Center(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: animation.value,
                width: animation.value,
                child: Stack(children: [
                  SvgPicture.asset(
                    'assets/images/eth_wallet.svg',
                    color: Colors.white.withOpacity(0.8),
                    matchTextDirection: true,
                    height: size.height * 0.6,
                  ),
                  Logo(width: animation.value * 0.65),
                ])),
          ),
        ],
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  _LoadingPageState createState() => _LoadingPageState();
}

// #docregion  -state
class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool condition;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1800), vsync: this);
    animation = Tween<double>(begin: 320, end: 350).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addStatusListener((state) => ('$state'));
    controller.forward();
    Future.delayed(Duration(milliseconds: 3500), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => (MyHomePage())));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
  }
}
