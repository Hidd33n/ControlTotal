import 'package:calcu/assets/widgets/slider/slider_button.dart';
import 'package:calcu/assets/widgets/slider/slider_skip_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/slider/slider1.dart';
import '../widgets/slider/slider2.dart';
import '../widgets/slider/slider3.dart';
import 'package:calcu/assets/widgets/slider/dots.dart';

class OnBoardingLayoutView extends StatefulWidget {
  const OnBoardingLayoutView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardingLayoutViewState();
}

class _OnBoardingLayoutViewState extends State<OnBoardingLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
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
                    return Slider1();
                  case 1:
                    return Slider2();
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
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Ajusta el espacio inferior
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
