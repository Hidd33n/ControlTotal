import 'package:calcu/presentation/landing/slider_landing/slider_button.dart';
import 'package:calcu/presentation/landing/slider_landing/slider_skip_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcu/presentation/landing/slider_landing/slider1.dart';
import 'package:calcu/presentation/landing/slider_landing/slider2.dart';
import 'package:calcu/presentation/landing/slider_landing/slider3.dart';
import 'package:calcu/presentation/landing/slider_landing/dots.dart';

class OnBoardingLayoutView extends StatefulWidget {
  const OnBoardingLayoutView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardingLayoutViewState();
}

class _OnBoardingLayoutViewState extends State<OnBoardingLayoutView> {
  late SharedPreferences _prefs;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = _prefs.getBool('onboarding_completed') ?? false;

    if (onboardingCompleted) {
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  _markOnboardingAsCompleted() {
    _prefs.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) => SliderLayout();

  // ignore: non_constant_identifier_names
  Widget SliderLayout() => Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: 3,
              itemBuilder: (ctx, i) {
                switch (i) {
                  case 0:
                    return const Slider1();
                  case 1:
                    return const Slider2();
                  case 2:
                    return Slider3();
                  default:
                    return Container();
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (_currentPage < 2)
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: SliderButtonskip(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            buttonText: 'skip'.tr(),
                          ),
                        ),
                    ],
                  ),
                  if (_currentPage == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SliderButton(
                          onPressed: () {
                            _markOnboardingAsCompleted();
                            Navigator.pushReplacementNamed(context, "/");
                          },
                          buttonText: 'start'.tr(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Dots(
                    currentPage: _currentPage,
                    pageCount: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
