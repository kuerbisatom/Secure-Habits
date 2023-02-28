import 'package:app/data/data.dart';
import 'package:app/src/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../src/widgets.dart';
import 'home.dart';

String user = "";

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PasswordForm();
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);


  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm>{
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Please sign in with the username and password provided to you via e-mail.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your username to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            //Sign In
                            user = _emailController.text;
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text +
                                          '@kuerbisatom.com',
                                      password: _passwordController.text);
                              // Check if start day already exists
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WaitingWidget()),
                                (Route<dynamic> route) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              _showErrorDialog(context, 'Failed to sign in', e);
                            }
                          }
                        },
                        child: const Text('SIGN IN'),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ToDo: Progressing Indicator for Sign In
class WaitingWidget extends StatefulWidget {
  const WaitingWidget({Key? key}) : super(key: key);

  @override
  State<WaitingWidget> createState() => _WaitingWidgetState();
}

class _WaitingWidgetState extends State<WaitingWidget> {
  final NotificationService _notificationService = NotificationService();

  Future _setUp() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setStringList('notiTime',
        [notificationTime.hour.toString(), notificationTime.minute.toString()]);

    //Enable Notifications
    await _notificationService.zonedScheduleNotification(notificationTime);

    return FirebaseFirestore.instance
        .collection('user')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        // User does not exist!
        // Create StartDate Document
        _prefs.setString('startDate', DateTime.now().toString());
        _prefs.setString('date',
            DateTime.now().subtract(const Duration(days: 1)).toString());
        _prefs.setInt('cur', 0);
        _prefs.setInt('done', 0);
        _prefs.setStringList('f_tasks', []);
        cur = 0;
        done = 0;
        startDate = DateTime.now();
        dayTask = DateTime.now().subtract(const Duration(days: 1));
        FirebaseFirestore.instance.collection('user').add(<String, dynamic>{
          'startDate': DateTime.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'userName': user,
          'lastTask': DateTime.now().subtract(const Duration(days: 1)),
          'cur': 0,
          'done': 0,
          'f_tasks': [],
        });
        // Save that OnBoarding is Already Viewed
        _prefs.setBool('boarding', false);
      } else {
        //User exists
        // Get startDate

        done = querySnapshot.docs.single.get('done');
        Timestamp time = querySnapshot.docs.single.get("startDate");
        startDate =
            DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
        time = querySnapshot.docs.single.get("lastTask");
        //Get correctValue
        finishedTasks = querySnapshot.docs.single.get('f_tasks');
        dayTask =
            DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);

        cur = querySnapshot.docs.single.get('cur');
        if (DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .difference(DateTime(dayTask.year, dayTask.month, dayTask.day))
                .inDays >
            1) {
          cur = 0;
        }

        //Save Start Date
        _prefs.setString('startDate', startDate.toString());
        _prefs.setString('date', dayTask.toString());
        _prefs.setInt('cur', cur);
        _prefs.setInt('done', done);
        _prefs.setStringList('tasks', listDynamic_to_listString(finishedTasks));
        // Save that OnBoarding is Already Viewed
        _prefs.setBool('boarding', false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _setUp(), // a previously-obtained Future<String> or null
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                  body: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Signing In ...',
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                ],
              )));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        .difference(DateTime(
                            startDate.year, startDate.month, startDate.day))
                        .inDays >
                    29) {
                  return Finished();
                }
                return const HomePage(title: 'Secure Habits');
              }
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //     const HomePage(title: 'Secure Habits')),
            //     (Route<dynamic> route) => false,
            // );
            default:
              print("default");
              return CircularProgressIndicator();
          }
        });

    //   if(snapshot.hasData){
    //     print('Hasdata');
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //           const HomePage(title: 'Secure Habits')),
    //           (Route<dynamic> route) => false,
    //     );
    //     return const Text('Hi');
    //   } else {
    //
    //   }
    // });
  }
}

void _showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '${(e as dynamic).message}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          StyledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      );
    },
  );
}

List<String> listDynamic_to_listString(List<dynamic> list) {
  List<String> temp = [];
  list.forEach((element) {
    temp.add(element.toString());
  });
  return temp;
}
