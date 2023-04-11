import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<ParseResponse> createDoctor(doctorName, doctorPhone, doctorEmail, doctorOther) async {
  var user = await ParseUser.currentUser();

  var doctor = ParseObject('Doctor');
  doctor.set('user_id', user);
  doctor.set('name', doctorName);
  doctor.set('phone', doctorPhone);
  doctor.set('email', doctorEmail);
  doctor.set('other_info', doctorOther);
  return await doctor.save();
}