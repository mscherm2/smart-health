import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../services/about_med_service.dart';

class AboutMedPage extends StatelessWidget {
  // TODO: parse get data here
  final List<String> entries = <String>['A', 'B', 'C'];

  final List<int> colorCodes = <int>[600, 300, 100];

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
                  AppBar(
                    title: Text("About My Medications", style: TextStyle(color: Colors.white),),
                    centerTitle: true,
                    backgroundColor: Color(0xff020887),
                  ),
                  SizedBox(height: 20),
                  Text("Hello, ${snapshot.data?[0].get('username')}! Use this page to see your medication details or add a new one!"),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data?[1].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 100,
                          color: Colors.lightGreen[colorCodes[index % 3]],
                          child: Center(child: Text('Name: ${snapshot.data?[1][index].get('Name')}\nDescription: ${snapshot.data?[1][index].get('Desc')}\nDays: ${snapshot.data?[1][index].get('Days')}\nTime: ${snapshot.data?[1][index].get('Time')}', textAlign: TextAlign.center,)),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),
                ],
              );
            } else {
              return Text("Hello");
            }
          }

        ),
    );
  }
}