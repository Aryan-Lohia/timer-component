import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class CountdownPage extends StatefulWidget {
  final Duration duration;
  final callBack;
  const CountdownPage({Key? key,required this.duration, required this.callBack}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;
  bool started = false;
  bool soundOn = true;
  AudioPlayer player = AudioPlayer();

  String get countText {
    Duration count = controller.duration! * controller.value;
    return '${(count.inMinutes % 60).toString().padLeft(2, '0')} : ${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;
  String prevBeep = "";

  void notify() async {
    if (countText.compareTo("00 : 05") <= 0 && countText!="00 : 00" && prevBeep != countText && soundOn) {
      prevBeep = countText;
      await player.play(
        AssetSource("tick.mp3"),
      );
    }
    if(countText=="00 : 00")
      {
        widget.callBack();
      }
  }

  void togglePlayPause() {
    if (controller.isAnimating) {
      controller.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
      setState(() {
        isPlaying = true;
        started = true;
      });
    }
  }

  void stop() {
    controller.reset();
    widget.callBack();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    );
    controller.duration = widget.duration;
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    controller.stop();
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
    setState(() {
      isPlaying = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 160,
              backgroundColor: Color.fromARGB(255, 149, 149, 153),
            ),
            const CircleAvatar(
              radius: 130,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            countText,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "minutes remaining",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.withOpacity(1)),
                        ),
                      ],
                    ),
                  ),
                  ShaderMask(
                      shaderCallback: (rect) {
                        return SweepGradient(
                            startAngle: 0,
                            endAngle: 2 * 3.14,
                            transform: const GradientRotation(-3.141 / 2),
                            stops: [controller.value, 0],
                            // value from Tween Animation Builder
                            // 0.0 , 0.5 , 0.5 , 1.0
                            center: Alignment.center,
                            colors: const [
                              Color.fromRGBO(63, 174, 80, 1),
                              Color.fromRGBO(231, 231, 231, 1)
                            ]).createShader(rect);
                      },
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: Image.asset("assets/spokes.png")
                                    .image)),
                      )),
                  ShaderMask(
                      shaderCallback: (rect) {
                        return SweepGradient(
                            startAngle: 0,
                            endAngle: 2 * 3.14,
                            transform: const GradientRotation(-3.141 / 2),
                            stops: [controller.value, 0],
                            // value from Tween Animation Builder
                            // 0.0 , 0.5 , 0.5 , 1.0
                            center: Alignment.center,
                            colors: const [
                              Color.fromRGBO(63, 174, 80, 1),
                              Colors.transparent
                            ]).createShader(rect);
                      },
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: Image.asset("assets/circle.png")
                                    .image)),
                      )),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Transform.scale(
          scale: 1.7,
          child: Switch(
            value: soundOn,
            onChanged: (value) {
              setState(() {
                soundOn = value;
              });
            },
            activeColor: const Color.fromRGBO(24, 197, 90, 1),
            thumbColor: const MaterialStatePropertyAll(Colors.white),
          ),
        ),
        const Text(
          "Sound On",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        started
            ? Column(
          children: [
            InkWell(
                onTap: togglePlayPause,
                child: GreenButton(
                  child: Text(
                    isPlaying ? "PAUSE" : "PLAY",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: stop,
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3))),
                  child: const Center(
                    child: Text(
                      "LET'S STOP I'M FULL NOW",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                )),
          ],
        )
            : InkWell(
          onTap: togglePlayPause,
          child: const GreenButton(
            child: Text(
              "START",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
class GreenButton extends StatelessWidget {
  final Widget child;

  const GreenButton({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(207, 236, 218, 1),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 144, 192, 159), offset: Offset(0, 5))
          ]),
      child: Center(child: child),
    );
  }
}