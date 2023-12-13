import 'package:flutter/material.dart';
import 'package:timer/timerWidget.dart';

class PageGenerator extends StatelessWidget {
  final String title;
  final String desc;
  final Duration duration;
  final callBack;

  const PageGenerator(
      {Key? key,
      required this.title,
      required this.desc,
      required this.duration,
      required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(
            height: 20,
          ),
          duration.compareTo(const Duration(minutes: 0)) != 0
              ? CountdownPage(duration: duration, callBack: callBack)
              : Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.asset("assets/completed.png"),
                )
        ],
      ),
    );
  }
}
