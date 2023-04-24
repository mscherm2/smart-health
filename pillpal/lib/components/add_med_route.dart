import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../main.dart';
import '../services/about_med_service.dart';
import 'MyHomePage.dart';
import 'cameraScreen.dart';

class AddMedRoute extends StatefulWidget {
  const AddMedRoute({super.key, required this.pillImagePath});

  final String pillImagePath;

  @override
  State<AddMedRoute> createState() => _AddMedRouteState();
}

class _AddMedRouteState extends State<AddMedRoute> {
  final _formKey = GlobalKey<FormState>();

  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();
  var controllerDays = [];
  final controllerHowManyTimes = TextEditingController();
  var controllerTimes = [];
  final controllerAmount = TextEditingController();
  final controllerDoses = TextEditingController();

  //DateTime _dateTime = DateTime.now();
  var allTimes = {};

  List<DayInWeek> _days = [
    DayInWeek(
      "Sun",
    ),
    DayInWeek(
      "Mon",
    ),
    DayInWeek(
      "Tue",
    ),
    DayInWeek(
      "Wed",
    ),
    DayInWeek(
      "Thu",
    ),
    DayInWeek(
      "Fri",
    ),
    DayInWeek(
      "Sat",
    ),
  ];

  final firstCamera = cameras.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('medroutetitle').tr(),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                      children: <Widget>[
                        // insert picture button
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CameraScreen(camera: firstCamera,)),
                                    );
                                  },
                                  child: Text("medroutepicture").tr(),
                                )
                              ],
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'medroutename'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'requiredfield'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerDescription,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'medroutedesc'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'requiredfield'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        Text('medroutedaysofweek', style: TextStyle(fontSize: 16),).tr(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectWeekDays(
                            fontSize:16,
                            fontWeight: FontWeight.w500,
                            days: _days,
                            border: false,
                            boxDecoration: BoxDecoration(
                              //borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
                                tileMode:
                                TileMode.repeated, // repeats the gradient over the canvas
                              ),
                            ),
                            onSelect: (values) { // <== Callback to handle the selected days
                              // values is the list of selected days
                              //print(values);
                              controllerDays = values;
                              //print(controllerDays);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerHowManyTimes,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'How many times a day?',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'requiredfield'.tr();
                              }
                              return null;
                            },
                          ),
                        ),

                        // first time picker
                        Text('Time 1:', style: TextStyle(fontSize: 16),),
                        TimePickerSpinner(
                          spacing: 20,
                          minutesInterval: 15,
                          itemHeight: 40,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              //_dateTime = time;
                              //allTimes[0].add(time);
                              allTimes['1'] = time;
                            });
                          },
                        ),

                        // rest of time pickers if applicable
                        if (controllerHowManyTimes.text.isNotEmpty)...[
                          for(int x = 2; x <= int.parse(controllerHowManyTimes.text); x++)...[
                            Text('medroutetime').tr(args: [x.toString()]),
                            TimePickerSpinner(
                              spacing: 20,
                              minutesInterval: 15,
                              itemHeight: 40,
                              isForce2Digits: true,
                              onTimeChange: (time) {
                                setState(() {
                                  //_dateTime = time;
                                  //allTimes[x-1].add(time);
                                  allTimes['$x'] = time;
                                });
                              },
                            ),
                          ],
                        ],

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerAmount,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'medrouteamt'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'requiredfield'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerDoses,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'medroutedosecnt'.tr(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'requiredfield'.tr();
                              }
                              return null;
                            },
                          ),
                        ),

                        if (widget.pillImagePath.contains('asset')) ...[
                          Image.asset(widget.pillImagePath)
                        ] else ...[
                          Image.file(File(widget.pillImagePath))
                        ],
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {

                                    // add times to list
                                    allTimes.forEach((k,v) => controllerTimes.add(v));

                                    // method call to create new medication in parse
                                    var medResponse = await createMed(controllerName.text, controllerDescription.text, controllerDays, controllerTimes, int.parse(controllerAmount.text), int.parse(controllerDoses.text), widget.pillImagePath);

                                    // display message to u45:58.000}ser that it worked
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('medroutesnackbar').tr()),
                                    );

                                    var doseCount = int.parse(controllerDoses.text);
                                    var amt = int.parse(controllerAmount.text);
                                    List<DateTime>? notificationTimes = controllerTimes.cast<DateTime>();

                                    var weekdayInts = [];
                                    for (var day in controllerDays) {
                                      switch(day) {
                                        case "Mon": {
                                          weekdayInts.add(1);
                                        }
                                        break;
                                        case "Tue": {
                                          weekdayInts.add(2);
                                        }
                                        break;
                                        case "Wed": {
                                          weekdayInts.add(3);
                                        }
                                        break;
                                        case "Thu": {
                                          weekdayInts.add(4);
                                        }
                                        break;
                                        case "Fri": {
                                          weekdayInts.add(5);
                                        }
                                        break;
                                        case "Sat": {
                                          weekdayInts.add(6);
                                        }
                                        break;
                                        case "Sun": {
                                          weekdayInts.add(7);
                                        }
                                        break;
                                      }
                                    }

                                    while (!weekdayInts.contains(notificationTimes[0].weekday)) {
                                      notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                                      notificationTimes.removeAt(0);
                                    }

                                    if (medResponse.success) {
                                      while (notificationTimes.isNotEmpty) {
                                          if (DateTime.now().compareTo(notificationTimes[0]) < 0) {
                                            NotificationController.scheduleNewNotification(
                                              medResponse.result["objectId"],
                                              medResponse.result["Name"],
                                              'notificationprompt'.tr(),
                                              medResponse.result["Desc"],
                                              notificationTimes[0]
                                            );

                                            doseCount -= amt;

                                            if (doseCount <= 0) {
                                              break;
                                            }
                                          }

                                          notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                                          notificationTimes.removeAt(0);

                                          while (!weekdayInts.contains(notificationTimes[0].weekday)) {
                                            notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                                            notificationTimes.removeAt(0);
                                          }
                                        }
                                      }
                                    }

                                    // command to go back to previous page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHomePage()),
                                    );
                                },
                                child: Text('submit').tr(),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                  );
                                },
                                child: Text('goback').tr(),
                              ),
                            ],
                          ),
                        ),
                      ]

                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}