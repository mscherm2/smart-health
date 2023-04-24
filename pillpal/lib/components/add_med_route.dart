import 'dart:io';

import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../services/about_med_service.dart';
import '../main.dart';
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
        title: const Text('Add a New Medication'),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Medication Name',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
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
                              labelText: 'Description',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Text('When to Take: Select days of week', style: TextStyle(fontSize: 16),),
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
                                return 'This field is required';
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
                            Text('Time $x:'),
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
                              labelText: 'Amount to Take at a Time?',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
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
                              labelText: 'How many doses do you have to start with?',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        // camera
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
                                child: Text("Add a picture"),
                              )
                            ],
                          )
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
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {

                                    // add times to list
                                    allTimes.forEach((k,v) => controllerTimes.add(v));

                                    // method call to create new medication in parse
                                    createMed(controllerName.text, controllerDescription.text, controllerDays, controllerTimes, int.parse(controllerAmount.text), int.parse(controllerDoses.text), widget.pillImagePath);

                                    // display message to u45:58.000}ser that it worked
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Medication added!')),
                                    );

                                    // command to go back to previous page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHomePage()),
                                    );
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                  );
                                },
                                child: const Text('Go back!'),
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