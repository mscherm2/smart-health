import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../main.dart';
import '../services/about_med_service.dart';

class AddMedRoute extends StatefulWidget {
  const AddMedRoute({super.key});

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
                                    var medResponse = await createMed(controllerName.text, controllerDescription.text, controllerDays, controllerTimes, int.parse(controllerAmount.text), int.parse(controllerDoses.text));

                                    // display message to u45:58.000}ser that it worked
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Medication added!')),
                                    );

                                    var doseCount = int.parse(controllerDoses.text);
                                    var amt = int.parse(controllerAmount.text);
                                    List<DateTime>? notificationTimes = controllerTimes.cast<DateTime>();

                                    print("THIS IS MY MEDRESPONSE");
                                    print(medResponse.result);

                                    if (medResponse.success) {

                                      while (notificationTimes.isNotEmpty) {
                                          if (DateTime.now().compareTo(notificationTimes[0]) < 0) {
                                            NotificationController.scheduleNewNotification(
                                              medResponse.result["objectId"],
                                              medResponse.result["Name"],
                                              "Time to take your " + medResponse.result["Name"] + "!",
                                              medResponse.result["Desc"],
                                              notificationTimes[0]
                                            );

                                            doseCount -= amt;

                                            if (doseCount <= 0) {
                                              break;
                                            }
                                          }

                                          notificationTimes.add(notificationTimes[0].add(Duration(days: 1)));
                                          notificationTimes.remove(0);
                                          print(notificationTimes);
                                        }
                                      }
                                    }

                                    // command to go back to previous page
                                    Navigator.pop(context);
                                  },
                                child: const Text('Submit'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
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