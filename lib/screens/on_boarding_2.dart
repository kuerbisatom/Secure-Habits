import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../src/widgets.dart';
import 'home.dart';
import 'sign_in.dart';

//ToDo: Make it a litte bit nicer!!! Add Time to notification!

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => const HomePage(
                title: "Secure Habits",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: const Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(top: 16, right: 16), child: Text("")),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Secure Habits",
          bodyWidget: Column(children: const [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Welcome to our user study.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'For 30 days, each day the application will give you a new task that needs to be done.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'After each completed task, a questionnaire needs to be filled out.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'For each task, you can find step-by-step instructions. Do not forget to read them, since they help you do the tasks correctly!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "'View Finished Tasks' allows you to see all tasks, with their description and instructions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ]),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center,
          ),
        ),
        PageViewModel(
          title: "Notifications",
          bodyWidget: TimePicker(),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center,
          ),
        ),
        PageViewModel(
          title: "Sign In",
          bodyWidget: const SignIn(),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center,
          ),
          reverse: false,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      showDoneButton: false,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
