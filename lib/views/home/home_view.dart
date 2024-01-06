import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/utils/constanst.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task1.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';
import 'package:todo_app/views/task/task_view.dart';
import '../../utils/strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          //  Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,

              /// Floating Action Button
              floatingActionButton: const FAB(),

              /// Body
              body: SliderDrawer(
                isDraggable: false,
                key: dKey,
                animationDuration: 1000,

                /// My AppBar
                appBar: MyAppBar(
                  drawerKey: dKey,
                ),

                /// My Drawer Slider
                slider: MySlider(),

                /// Main Body
                child: _buildBody(
                  tasks,
                  base,
                  textTheme,
                ),
              ),
            ),
          );
        });
  }

  /// Main Body
  SizedBox _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          /// Top Section Of Home page : Text, Progrss Indicator
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// CircularProgressIndicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation(Colors.blueGrey),
                    backgroundColor: Colors.white,
                    value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                ),

                /// Texts
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(MyString.mainTitle,
                        style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
                    // const SizedBox(
                    //   height: 2,
                    //   width: 2,
                    // ),
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.blueGrey)),
                  ],
                )
              ],
            ),
          ),

          // Bottom ListView : Tasks
          SizedBox(
            width: double.infinity,
            height: 590,
            child: tasks.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          var task = tasks[index];

                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            background: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(MyString.deletedTask,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                            onDismissed: (direction) {
                              base.dataStore.deleteTask(task: task);
                            },
                            key: Key(task.id),
                            child: TaskWidget(
                              task: tasks[index],
                            ),
                          );
                        },
                      ),
                    ),
                  )

                /// if All Tasks Done Show this Widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Lottie
                      // FadeIn(
                      //   child: SizedBox(
                      //     width: 200,
                      //     height: 200,
                      //     child: Lottie.asset(
                      //       lottieURL,
                      //       animate: tasks.isNotEmpty ? false : true,
                      //     ),
                      //   ),
                      // ),

                      /// Bottom Texts
                      FadeInUp(
                        from: 10,
                        child: const Text(
                          MyString.doneAllTask,
                          // style: TextStyle(
                          //     fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

/// My Drawer Slider
class MySlider extends StatefulWidget {
  const MySlider({
    Key? key,
  }) : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  /// Icons
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.calendar,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  List<String> texts = [
    "Home",
    "Profile",
    "calendar",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
        // gradient: LinearGradient(
        //     colors: Colors.accents,
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const Center(
              child: Text(
            ' P R O F I L E',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 6,
          ),
          const Text("Habeeba  Nazrin",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return InkWell(
                    // ignore: avoid_print
                    onTap: () => print("$i Selected"),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                          leading: Icon(
                            icons[i],
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            texts[i],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

/// My App Bar
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({
    Key? key,
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon aniamtion
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Animated Icon - Menu & Close
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    color: Colors.blueGrey,
                    progress: controller,
                    size: 30,
                  ),
                  onPressed: toggle),
            ),

            // Delete Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty
                      ? warningNoTask(context)
                      : deleteAllTask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 40,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
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
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
