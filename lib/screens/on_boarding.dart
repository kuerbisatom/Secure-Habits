import 'package:app/src/dot_indicator.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}


class _OnBoardingState extends State<OnBoarding> {

  final PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );

  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: const FlutterLogo(),
    ),
    ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: const FlutterLogo(),
    ),
    const SignIn(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconTheme(
        data: IconThemeData(color: _kArrowColor),
        child: Stack(
          children: <Widget>[
            PageView.builder(
                itemCount: _pages.length,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.grey[800]?.withOpacity(0.5),
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                      ),
                    ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}

