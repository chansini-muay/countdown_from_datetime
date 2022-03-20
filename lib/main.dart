import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Countdown DateTime',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'hello world !',
            ),
            CountdownDateTime(
              endtime: DateTime.parse("2022-03-20 14:13:59"),
            )
          ],
        ),
      ),
    );
  }
}

class CountdownDateTime extends StatefulWidget {
  const CountdownDateTime({Key? key, required this.endtime}) : super(key: key);
  final DateTime endtime;

  @override
  _CountdownDateTimeState createState() => _CountdownDateTimeState();
}

class _CountdownDateTimeState extends State<CountdownDateTime> {
  String remainingTime = "";
  Timer? _timer;
  StreamController<String> timerStream = StreamController<String>.broadcast();
  final currentDate = DateTime.now();

  @override
  void initState() {
    prepareData();
    super.initState();
  }

  @override
  void dispose() {
    try {
      if (_timer != null && _timer!.isActive) _timer!.cancel();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  prepareData() {
    // final difference = daysBetween(currentDate, widget.endtime);
    var result = const Duration(seconds: 0);
    result = widget.endtime.difference(currentDate);
    remainingTime = result.inSeconds.toString(); // convert to second
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  String dayHourMinuteSecondFunction(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return days +
        ' ' +
        "Days" +
        ' ' +
        twoDigitHours +
        ' ' +
        "Hours" +
        ' ' +
        twoDigitMinutes +
        ' ' +
        "Minutes" +
        ' ' +
        twoDigitSeconds +
        "Seconds";
  }

  Widget dateWidget() {
    return StreamBuilder<String>(
        stream: timerStream.stream,
        initialData: "0",
        builder: (cxt, snapshot) {
          const oneSec = Duration(seconds: 1);
          if (_timer != null && _timer!.isActive) _timer!.cancel();
          _timer = Timer.periodic(oneSec, (Timer timer) {
            try {
              int second = int.tryParse(remainingTime) ?? 0;
              second = second - 1;
              if (second < -1) return;
              remainingTime = second.toString();
              if (second == -1) {
                timer.cancel();
                print('timer cancelled');
              }
              if (second >= 0) {
                timerStream.add(remainingTime);
              }
            } catch (e) {
              print(e);
            }
          });
          String remainTimeDisplay = "-";
          try {
            int seconds = int.parse(remainingTime);
            var now = Duration(seconds: seconds);
            remainTimeDisplay = dayHourMinuteSecondFunction(now);
          } catch (e) {
            print(e);
          }
          print(remainTimeDisplay);
          return Text(
            remainTimeDisplay,
            textAlign: TextAlign.center,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return dateWidget();
  }
}
