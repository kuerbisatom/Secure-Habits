import 'package:app/data/data.dart';

int findTask(int temp) {
  List<String> openTasks;
  openTasks = checkTor(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  openTasks = checkHTTPS(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  openTasks = checkLogin(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  openTasks = checkTwoFactor(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  openTasks = checkTwoFactor(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  openTasks = checkSignal(temp);
  if (openTasks.isNotEmpty) {
    return int.parse(openTasks[0]) - 1;
  }
  if (finishedTasks.contains("1")) {
    openTasks = checkBackUp(temp);
    if (openTasks.isNotEmpty) {
      return int.parse(openTasks[0]) - 1;
    }
  }
  if (finishedTasks.contains("3")) {
    openTasks = checkPWM(temp);
    if (openTasks.isNotEmpty) {
      return int.parse(openTasks[0]) - 1;
    } else {
      if (!finishedTasks.contains("5")) {
        return 5 - 1;
      }
      openTasks = checkLogPWM(temp);
      if (openTasks.isNotEmpty) {
        return int.parse(openTasks[0]) - 1;
      }
    }
  }
  if (!finishedTasks.contains("2")) {
    return 2 - 1;
  }
  if (!finishedTasks.contains("4")) {
    return 4 - 1;
  }
  return 31 - 1;
}

List<String> checkUpdate(int x) {
  List<String> temp = ["1", "8", "15", "22", "29"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkPWM(int x) {
  List<String> temp = ["3", "6", "13", "20", "27"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkLogPWM(int x) {
  List<String> temp = ["18", "24", "26"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkBackUp(int x) {
  List<String> temp = ["4", "9", "16", "23", "30"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkTor(int x) {
  List<String> temp = ["7", "14", "21", "28"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkSetUp(int x) {
  List<String> temp = ["2", "3", "4"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkSignal(int x) {
  List<String> temp = ["17", "25"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkTwoFactor(int x) {
  List<String> temp = ["10", "19"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkLogin(int x) {
  List<String> temp = ["11"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkHTTPS(int x) {
  List<String> temp = ["12"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

List<String> checkDoublePW(int x) {
  List<String> temp = ["5"];
  List<String> answer = [];
  if (temp.any((String u) => int.parse(u) < x && !finishedTasks.contains(u))) {
    temp.forEach((String task) {
      if (int.parse(task) < x && !finishedTasks.contains(task)) {
        answer.add(task);
      }
    });
  }
  ;
  return answer;
}

int getTask() {
  int temp = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .difference(DateTime(startDate.year, startDate.month, startDate.day))
          .inDays +
      1;
  List<String> openTasks = [];
  if (temp == 19) {
    if (!finishedTasks.contains("10")) {
      return 10 - 1;
    }
  }
  if (temp == 25) {
    if (!finishedTasks.contains("17")) {
      return 17 - 1;
    }
  }
  if (temp == 14 || temp == 21 || temp == 28) {
    openTasks = checkTor(temp);
    if (openTasks.isNotEmpty) {
      return int.parse(openTasks[0]) - 1;
    }
  }
  //PWM
  if (temp == 8 || temp == 15 || temp == 22 || temp == 29) {
    openTasks = checkUpdate(temp);
    if (openTasks.isNotEmpty) {
      int curr = int.parse(openTasks[0]);
      if (temp <= 15 || curr != 1) {
        return curr - 1;
      } else {
        openTasks = checkSetUp(temp);
        if (!openTasks.contains("3")) {
          openTasks = checkPWM(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          } else {
            if (checkDoublePW(temp).isNotEmpty) {
              return 5 - 1;
            } else {
              openTasks = checkLogPWM(temp);
              if (openTasks.isNotEmpty) {
                return int.parse(openTasks[0]) - 1;
              }
            }
          }
        } else {
          return findTask(temp);
        }
      }
    } else {
      return temp - 1;
    }
  }

  if (temp == 11) {
    if (!finishedTasks.contains("2")) {
      return 2 - 1;
    } else {
      if (!finishedTasks.contains("3")) {
        return 3 - 1;
      } else {
        if (!finishedTasks.contains("4")) {
          return 4 - 1;
        } else {
          if (!finishedTasks.contains("1")) {
            return 1 - 1;
          }
        }
      }
    }
  }
  if (temp == 18 || temp == 24 || temp == 26) {
    if (temp == 18) {
      openTasks = checkSetUp(temp);
      if (openTasks.isNotEmpty) {
        if (!finishedTasks.contains("3")) {
          return 3 - 1;
        } else {
          if (!finishedTasks.contains("4")) {
            return 4 - 1;
          }
        }
      } else {
        if (!finishedTasks.contains("1")) {
          return 1 - 1;
        } else {
          openTasks = checkPWM(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        }
      }
    } else {
      openTasks = checkSetUp(temp);
      if (openTasks.length == 3) {
        if (finishedTasks.contains("1")) {
          openTasks = checkUpdate(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          } else {
            return findTask(temp);
          }
        } else {
          return findTask(temp);
        }
      } else {
        if (finishedTasks.contains("3")) {
          openTasks = checkPWM(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          } else {
            if (!finishedTasks.contains("5")) {
              return 5 - 1;
            } else {
              openTasks = checkLogPWM(temp);
              if (openTasks.isNotEmpty) {
                return int.parse(openTasks[0]) - 1;
              }
            }
          }
        }
        if (finishedTasks.contains("1")) {
          openTasks = checkUpdate(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        }
        if (finishedTasks.contains("4")) {
          openTasks = checkUpdate(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        }
        return findTask(temp);
      }
    }
  }
  //BackUp
  if (temp == 9 || temp == 16 || temp == 23 || temp == 30) {
    openTasks = checkBackUp(temp);
    if (openTasks.isNotEmpty) {
      int curr = int.parse(openTasks[0]);
      if (temp <= 16 || curr != 4) {
        if (temp < 16) {
          if (!finishedTasks.contains("3")) {
            if (finishedTasks.contains("2")) {
              return 3 - 1;
            } else {
              return 2 - 1;
            }
          }
        }
        return curr - 1;
      } else {
        openTasks = checkSetUp(temp);
        if (!openTasks.contains("3")) {
          openTasks = checkPWM(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          } else {
            if (checkDoublePW(temp).isNotEmpty) {
              return 5 - 1;
            } else {
              openTasks = checkLogPWM(temp);
              if (openTasks.isNotEmpty) {
                return int.parse(openTasks[0]) - 1;
              }
            }
          }
        }
        if (finishedTasks.contains("1")) {
          openTasks = checkUpdate(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        }
        return findTask(temp);
      }
    } else {
      return temp - 1;
    }
  }
  //PWM
  if (temp == 6 || temp == 13 || temp == 20 || temp == 27) {
    openTasks = checkPWM(temp);
    if (openTasks.isNotEmpty) {
      int curr = int.parse(openTasks[0]);
      if (temp <= 13 || curr != 3) {
        if (temp < 13) {
          if (!finishedTasks.contains("2")) {
            return 2 - 1;
          }
        }
        return curr - 1;
      } else {
        if (finishedTasks.contains("1")) {
          openTasks = checkUpdate(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        } else {}
        if (finishedTasks.contains("4")) {
          openTasks = checkBackUp(temp);
          if (openTasks.isNotEmpty) {
            return int.parse(openTasks[0]) - 1;
          }
        }
        return findTask(temp);
      }
    } else {
      return temp - 1;
    }
  }
  if (temp == 5) {
    if (!finishedTasks.contains("3")) {
      temp = 3;
    }
  }
  if (temp == 4) {
    if (!finishedTasks.contains("3")) {
      temp = 3;
    }
  }
  if (temp == 3) {
    if (!finishedTasks.contains("2")) {
      temp = 2;
    }
  }
  //Just do what Temp is!
  return temp - 1;
}
