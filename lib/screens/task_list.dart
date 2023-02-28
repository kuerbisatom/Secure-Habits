import 'package:app/data/data.dart';
import 'package:app/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // TaskList({Key? key}) : super(key: key);
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Task List',
        ),
      ),
      body: FutureBuilder(
          future: getIDs(),
          builder: (context, snapshot) {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: (DateTime(DateTime.now().year, DateTime.now().month,
                                  DateTime.now().day)
                              .difference(DateTime(startDate.year,
                                  startDate.month, startDate.day))
                              .inDays) +
                          1 >
                      30
                  ? 30
                  : (DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)
                          .difference(DateTime(
                              startDate.year, startDate.month, startDate.day))
                          .inDays) +
                      1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.green,
                  child: Material(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        key: Key(index.toString()),
                        title: Text('Task ' + (index + 1).toString()),
                        subtitle: Text(
                          category[index],
                        ),
                        trailing: createIcons(snapshot, index),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              tasks[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                              child: TextButton(
                            child: Text('Task Instructions'),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Step-by-Step Instruction'),
                                  content: SingleChildScrollView(
                                    child: Text(inst[index]),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (_customTileExpanded) {
                          } else {
                            setState(() => _customTileExpanded = expanded);
                          }
                        },
                      ),
                    ),
                  ),
                );

                // Container(
                //   height: 80,
                //   color: Colors.cyan,
                //   child: Row(children: <Widget>[
                //     Expanded(
                //         child: Text(
                //       tasks[index],
                //       textAlign: TextAlign.center,
                //     )),
                //     createIcons(snapshot, index),
                //     // getIDs().contains(index+1)
                //     //     ? const Icon(Icons.check)
                //     //     : const Icon(Icons.clear)
                //   ]));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Color(0xFFB2EBF2),
                thickness: 1.5,
                indent: 7.5,
                endIndent: 7.5,
              ),
            );
          }),
    );
  }
}

createIcons(AsyncSnapshot snapshot, int index) {
  if (snapshot.hasData) {
    if (snapshot.data.contains(index + 1)) {
      return const Icon(Icons.check);
    } else {
      return const Icon(Icons.clear);
    }
  } else {
    return const CircularProgressIndicator();
  }
}
