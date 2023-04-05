import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:easy_localization/easy_localization.dart';

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
                  /*AppBar(
                    title: Text('aboutmymedications', style: TextStyle(color: Colors.white),).tr(),
                    centerTitle: true,
                    backgroundColor: Color(0xff020887),
                  ),*/
                  SizedBox(height: 20),
                  Text('aboutmymedsintro').tr(args: [snapshot.data?[0].get('username')]),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data?[1].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 140,
                          color: Colors.lightGreen[colorCodes[index % 3]],
                          child: Center(child: Text('medication',
                            textAlign: TextAlign.center,).tr(args: [
                              snapshot.data?[1][index].get('Name'),
                              snapshot.data?[1][index].get('Desc'),
                              snapshot.data?[1][index].get('Days'),
                              snapshot.data?[1][index].get('Time').join(", "),
                              snapshot.data?[1][index].get('amt').toRadixString(16),
                          ])),
                          /*child: Center(child: Text('Name: ${snapshot.data?[1][index].get('Name')}'
                              '\nDescription: ${snapshot.data?[1][index].get('Desc')}\nDays: ${snapshot.data?[1][index].get('Days')}'
                              '\nTime: ${snapshot.data?[1][index].get('Time').join(" ")}\nAmount: ${snapshot.data?[1][index].get('amt')}',
                            textAlign: TextAlign.center,)),*/
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),
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