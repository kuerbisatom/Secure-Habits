import 'dart:convert';

import 'package:app/data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_package/research_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'research_package_objects/linear_survey_objects.dart';

List<String> listDynamic_to_listString(List<dynamic> list) {
  List<String> temp = [];
  list.forEach((element) {
    temp.add(element.toString());
  });
  return temp;
}

class LinearSurveyPage extends StatelessWidget {
  Function callback;
  int currentTask;

  LinearSurveyPage(
      {Key? key, required this.callback, required this.currentTask})
      : super(key: key);

  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  void saving(RPTaskResult result) async {
    //Calculating Curr
    if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .difference(DateTime(dayTask.year, dayTask.month, dayTask.day))
            .inDays >
        1) {
      cur = 1;
    } else {
      cur = cur + 1;
    }
    done = done + 1;

    dayTask = DateTime.now();

    result.results['timeOfDayQuestionStepID'].results['answer'][0].value == 1
        ? finishedTasks.add((currentTask + 1).toString())
        : null;

    //Saving Data
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('cur', cur);
    _prefs.setInt('done', done);
    _prefs.setString('date', dayTask.toString());
    _prefs.setStringList('tasks', listDynamic_to_listString(finishedTasks));

    FirebaseFirestore.instance
        .collection('user')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.single.reference.update({
          'cur': cur,
          'lastTask': dayTask,
          'done': done,
          'f_tasks': finishedTasks,
        });
      }
    });

  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void resultCallback(RPTaskResult result) {
    // Do anything with the result
    // print(_encode(result));
    callback();
    saving(result);
    addMessageToGuestbook(
      result.results['timeOfDayQuestionStepID'].results['answer'][0].value,
      result.results['timeOfDayQuestionStepID'].results['answer'][0].value == 1
          ? result.results['dateAndTimeQuestionStepID'].results['answer']
          : result.results['sliderQuestionsStepID'].results['answer'],
      result.results['timeOfDayQuestionStepID'].results['answer'][0].value == 1
          ? result.results['dateQuestionStepID'].results['answer'][0].value
          : result.results['additionalQuestionStepID'].results['answer'],
      result.results['questionStep1ID'].results['answer'][0].value,
      result.results['booleanQuestionStepID'].results['answer'][0].value,
      result
          .results['instrumentChoiceQuestionStepID'].results['answer'][0].value,
      result.results['additionalInfoQuestionStepID'].results['answer'],
    );
    // printWrapped(_encode(result));
    // ToDo: For Showing SnackBar, get the right context!
    // final snackBar = SnackBar(
    //   content: Text('Survey succesfully submitted'),
    // );
    // ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
  }

  void cancelCallBack(RPTaskResult result) {
    // Do anything with the result at the moment of the cancellation
    // print("The result so far:\n" + _encode(result));
  }

  @override
  Widget build(BuildContext context) {
    task = currentTask;
    return RPUITask(
      task: linearSurveyTask,
      onSubmit: resultCallback,
      onCancel: (RPTaskResult? result) {
        if (result == null) {
          print("No result");
        } else
          cancelCallBack(result);
      },
    );
  }
}

Future<DocumentReference> addMessageToGuestbook(
  answer1,
  answer2,
  answer3,
  answer4,
  answer5,
  answer6,
  answer7,
) {
  final String user = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance.collection(user).add({
    'timestamp': DateTime.now(),
    'userId': user,
    'Task': tasks[task],
    'id': task + 1,
    'question1': answer1,
    'question2': answer2,
    'question3': answer3,
    'question4': answer4,
    'question5': answer5,
    'question6': answer6,
    'question7': answer7,
  });
}
