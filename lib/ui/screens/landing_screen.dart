import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _preferencesLoaded = false;

  @override
  void initState() {
    _loadPrefs();
    super.initState();
  }

  _loadPrefs() async {
    await Future.delayed(const Duration(milliseconds: 2500));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/launcher/launcher_icon_transparent.png',
              width: 40.0,
              height: 40.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'Gastei',
              style: Theme.of(context).textTheme.title,
            ),
          ],
        )));
  }
}
