library flutter_datetime_picker;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/constanst.dart';
import 'package:todo_app/models/task1.dart';
import '../../main.dart';
import '../../utils/strings.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  TaskView({
    Key? key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  }) : super(key: key);

  TextEditingController? taskControllerForTitle;
  TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: 600,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// new / update Task Text
                  _buildTopText(textTheme),

                  /// Middle Two TextFileds, Time And Date Selection Box
                  _buildMiddleTextFieldsANDTimeAndDateSelection(
                      context, textTheme),

                  /// All Bottom Buttons
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                )

              /// Delete Task Button
              : Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    color: Colors.blueGrey,
                    child: const Row(
                      children: [
                        Text(
                          MyString.deleteTask,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

          /// Add or Update Task Button
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.0),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ]),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minWidth: 100,
              height: 55,
              onPressed: () {
                isTaskAlreadyExistUpdateTask();
              },
              color: Colors.blueGrey,
              child: Text(
                isTaskAlreadyExistBool()
                    ? MyString.addTaskString
                    : MyString.updateTaskString,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(MyString.titleOfTitleTextField,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                )),
          ),

          /// Title TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 2,
                cursorHeight: 30,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),

          /// Note TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: MyString.addNote,
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),

          /// Time Picker
          GestureDetector(
            onTap: () {
              picker.DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false,
                  onChanged: (_) {}, onConfirm: (selectedTime) {
                setState(() {
                  if (widget.task?.createdAtTime == null) {
                    time = selectedTime;
                  } else {
                    widget.task!.createdAtTime = selectedTime;
                  }
                });

                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showTimeAsDateTime(time));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(MyString.timeString,
                        style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showTime(time),
                        style: const TextStyle(
                            fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /// Date Picker
          GestureDetector(
            onTap: () {
              picker.DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 3, 5),
                  onChanged: (_) {}, onConfirm: (selectedDate) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    date = selectedDate;
                  } else {
                    widget.task!.createdAtDate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showDateAsDateTime(date));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(MyString.dateString,
                        style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Text(
                        showDate(date),
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// new / update Task Text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? MyString.addNewTask
                    : MyString.updateCurrentTask,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: const [
                  TextSpan(
                    text: MyString.taskStrnig,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 50,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
