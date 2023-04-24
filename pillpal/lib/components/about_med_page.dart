import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../services/about_med_service.dart';
import './add_med_route.dart';

class AboutMedPage extends StatelessWidget {

  final List<int> colorCodes = <int>[100, 200, 300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: FutureBuilder(
          future: Future.wait([getUser(), getMeds()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.data?[0].username != null) {
              return Column(
                    children: [
                      SizedBox(height: 20),
                      Text('aboutmymedsintro', style: TextStyle(fontSize: 20, fontFamily: 'Poppins')).tr(args: [snapshot.data?[0].get('username')]),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?[1].length,
                          itemBuilder: (BuildContext context, int index) {
                            // format times
                            var timeList = snapshot.data?[1][index].get('Time');
                            var newTimeList = [];
                            timeList.forEach((element) =>
                                newTimeList.add(DateFormat.Hm().format(element.toLocal()))
                            );
                            var timeString = newTimeList.join(", ");

                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple[colorCodes[index % 3]],
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Text(snapshot.data?[1][index].get('Name'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                                    Text('medication', style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,).tr(args: [
                                      snapshot.data?[1][index].get('Desc'),
                                      snapshot.data?[1][index].get('days').join(", "),
                                      timeString,
                                      snapshot.data?[1][index].get('amt').toRadixString(10),
                                      snapshot.data?[1][index].get('doseCount').toRadixString(10),
                                    ]),
                                    if (snapshot.data?[1][index].get('Image') != null) ...[
                                      Image.network(
                                        snapshot.data?[1][index].get('Image')!.url!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ],
                                    SizedBox(height: 15),
                                  ],
                                ),
                            ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddMedRoute(pillImagePath: 'assets/images/add_med_placeholder.png')),
                            );
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add a Medication', style: TextStyle(fontSize: 20))
                      )
                    ],
              );
            } else {
              return Text("");
            }
          }

      ),
    );
  }
}