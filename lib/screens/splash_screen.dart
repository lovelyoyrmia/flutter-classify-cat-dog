import 'package:classify_cat_and_dog/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 8,
      navigateAfterSeconds: HomeScreen(),
      title: Text(
        'Classify cat and dog',
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      ),
      image: Image.asset('assets/images/dog.webp'),
      backgroundColor: Colors.lightBlue,
      photoSize: 200,
      loaderColor: Colors.amberAccent,
    );
  }
}
