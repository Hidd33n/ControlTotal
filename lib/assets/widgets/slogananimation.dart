import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';

class SloganAnim extends StatefulWidget {
  SloganAnim({Key? key}) : super(key: key);

  @override
  _SloganAnimState createState() => _SloganAnimState();
}

class _SloganAnimState extends State<SloganAnim> {
  @override
  @override
  Widget build(BuildContext context) {
    return TyperAnimatedTextKit(
      isRepeatingAnimation: false,
      speed: const Duration(milliseconds: 60),
      text: ['appsubtitle'.tr().toUpperCase()],
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: Colors.white,
      ),
    );
  }
}
