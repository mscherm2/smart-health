import 'package:flutter/material.dart';

class AboutMedPage extends StatelessWidget {
  // TODO: parse get data here
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 300, 100];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("About My Medications", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Color(0xff020887),

        ),
        SizedBox(height: 20),
        Text("Use this page to see your medication details or add a new one!"),
        SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Colors.lightGreen[colorCodes[index % 3]],
                child: Center(child: Text('Entry ${entries[index]}')),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ],
    );
  }
}