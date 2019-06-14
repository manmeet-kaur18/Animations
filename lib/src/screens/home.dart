import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  initState() // anytime instance of home created then this function will be already called upon
  {
    super.initState();
    boxController = AnimationController(
      duration: Duration(milliseconds:300),
      vsync: this,
    );

    boxAnimation = Tween(begin: pi*0.6, end: pi*0.65).animate(
      CurvedAnimation(
        //rete at which animation value changes from 0 to 100
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    boxAnimation.addStatusListener((status){
      if(status==AnimationStatus.completed)
      {
        boxController.reverse();
      }
      else if(status == AnimationStatus.dismissed)
      {
        boxController.forward();
      }
    });
    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        //rete at which animation value changes from 0 to 100
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() //results in movemnet only when taped or clicked on it
  {
    
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    } 
    //because of which it will start working
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(), //occurs behind box
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          // use to solve problem the problem of moving box along the cat
          child: child,
          top: catAnimation.value, // original value in catAnimation value
          right:
              0.0, //lead to shrinking of position element by giving right and left
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 110.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
          );
        },
      ),
    );
  }
  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 110.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
          );
        },
      ),
    );
  }
}
