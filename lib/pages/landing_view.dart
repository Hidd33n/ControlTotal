import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calcu/assets/ui/onboarding.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: OnBoardingLayoutView(),
      );
}
