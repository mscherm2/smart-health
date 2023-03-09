import 'package:flutter/material.dart';

class AboutMedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('About Med Page'),
          const Text('first line'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('first item'),
              SizedBox(width: 10),
              Text('second item'),
            ],
          ),
        ],
      ),
    );
  }
}