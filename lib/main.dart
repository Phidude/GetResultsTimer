import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pomodoro(),
    ));

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double percent = 0;
  static int initialTimeInMinutes = 25;
  int timeInMinutes = initialTimeInMinutes;
  int timeInSeconds = initialTimeInMinutes * 60;

  late Timer timer;
  bool isTimerRunning = false;

  _toggleTimer() {
    if (isTimerRunning) {
      timer.cancel();
    } else {
      _startTimer();
    }

    setState(() {
      isTimerRunning = !isTimerRunning;
      if (isTimerRunning) {
        // Add initial color change when timer starts
        percent = 0.01;
      }
    });
  }

  _startTimer() {
    int time = timeInMinutes * 60;
    double secondsPercent = (time / 100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          time--;
          if (time % 60 == 0) {
            timeInMinutes--;
          }
          if (time % secondsPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          timeInMinutes = initialTimeInMinutes;
          timer.cancel();
        }
      });
    });
  }

  _increaseTimer() {
    setState(() {
      initialTimeInMinutes++;
      timeInMinutes = initialTimeInMinutes;
      timeInSeconds = initialTimeInMinutes * 60;
      percent = 0;
    });
  }

  _decreaseTimer() {
    if (initialTimeInMinutes > 1) {
      setState(() {
        initialTimeInMinutes--;
        timeInMinutes = initialTimeInMinutes;
        timeInSeconds = initialTimeInMinutes * 60;
        percent = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {}, // Placeholder, add navigation logic
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 300.0,
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 150.0,
                  lineWidth: 10.0,
                  progressColor: Colors.cyanAccent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$timeInMinutes",
                        style:
                            TextStyle(color: Colors.cyanAccent, fontSize: 80.0),
                      ),
                      SizedBox(height: 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: _decreaseTimer,
                            color: Colors.cyanAccent,
                          ),
                          SizedBox(width: 0.0),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _increaseTimer,
                            color: Colors.cyanAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: _toggleTimer,
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    isTimerRunning ? "Stop" : "Start",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // Placeholder, add navigation logic
          child: Icon(Icons.arrow_forward),
          backgroundColor: Colors.cyanAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class VariableRewards extends StatefulWidget {
  @override
  _VariableRewardsState createState() => _VariableRewardsState();
}

class _VariableRewardsState extends State<VariableRewards> {
  List<String> rewardsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Variable Rewards',
          style: TextStyle(color: Colors.cyanAccent),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
        ),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: rewardsList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[850],
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rewardsList[index],
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 18.0,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                rewardsList.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  hintText: 'Add a new reward...',
                  hintStyle: TextStyle(color: Colors.cyanAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
                style: TextStyle(color: Colors.cyanAccent),
                onSubmitted: (text) {
                  setState(() {
                    rewardsList.add(text);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
        ),
        width: double.infinity,
        child: Center(
          child: Text(
            'This is the settings page!',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
