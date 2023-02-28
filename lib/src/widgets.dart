import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';

class Header extends StatelessWidget {
  Header(this.heading, this.size);

  final String heading;
  final double size;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: TextStyle(fontSize: 18),
        ),
      ));
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content);

  final String content;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      content,
      style: const TextStyle(fontSize: 18),
    ),
  );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail);

  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          detail,
          style: const TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.cyan)),
    onPressed: onPressed,
    child: child,
  );
}

class TimePicker extends StatefulWidget {
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 00);

  @override
  Widget build(BuildContext context) {
    String minute = selectedTime.minute < 10
        ? "0${selectedTime.minute}"
        : "${selectedTime.minute}";
    String hour = selectedTime.hour < 10
        ? "0${selectedTime.hour}"
        : "${selectedTime.hour}";
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Please select a time when you would like to receive notifications.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Each day you will get a notification at the chosen time.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Note that you need access to your computer for the tasks, so choose the time accordingly.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Choose carefully, since it is not possible to change it later.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Current Notification Time: $hour:$minute',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(fixedSize: Size(400, 75)),
          onPressed: () {
            _selectTime(context);
          },
          child: const Text(
            'Change Notification Time',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    ]);
  }

  // comment out /opt/flutter/packages/flutter/lib/src/material/time_picker.dart Line 2181-2190
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        notificationTime = timeOfDay;
      });
    }
  }
}

saveClick(String? data) async {
  FirebaseFirestore.instance.collection('telemetry').add({
    'user': FirebaseAuth.instance.currentUser!.uid,
    'click': data,
    'time': DateTime.now(),
  });
}