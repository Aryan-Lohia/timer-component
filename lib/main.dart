import 'package:flutter/material.dart';
import 'package:timer/pageGenerator.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimerApp(),
  ));
}

class TimerApp extends StatefulWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  PageController controller = PageController();
  int selectedIndex = 0;

  void nextPage() async {
    await controller.nextPage(
        duration: const Duration(seconds: 1), curve: Curves.ease);
  }

  List pages = [
    {
      "title": "Nom Nom :)",
      "desc":
          "You have 10 minutes to eat before the pause.\nFocus on eating slowly",
      "duration": const Duration(seconds: 30),
    },
    {
      "title": "Break Time",
      "desc": "Take a five minute break to check in on your level of fullness",
      "duration": const Duration(seconds: 10),
    },
    {
      "title": "Finish your Meal",
      "desc": "You can eat until you eat full",
      "duration": const Duration(seconds: 40),
    },
    {
      "title": "Meal Finished!",
      "desc": "You may now close this timer",
      "duration": const Duration(minutes: 0),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 22, 34),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            "Mindful Meal Timer",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.5)),
          ),
        ),
        body: PageView.builder(
            controller: controller,
            onPageChanged: (int page) {
              setState(() {
                selectedIndex = page;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              var page = pages[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selectedIndex == 3
                      ? Container()
                      : Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                  PageGenerator(
                    title: page['title'],
                    desc: page['desc'],
                    duration: page['duration'],
                    callBack: nextPage,
                  ),
                ],
              );
            }));
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4),
      child: CircleAvatar(
        radius: isActive ? 10 : 7,
        backgroundColor:
            isActive ? Colors.white : Colors.white.withOpacity(0.3),
      ),
    );
  }
}
