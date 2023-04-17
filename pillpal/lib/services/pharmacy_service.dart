import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<ParseResponse> createPharmacy(pharmacyName, pharmacyPhone, pharmacyAddr, pharmacyCity, pharmacyState, pharmacyZip) async {
  var user = await ParseUser.currentUser();

  var pharmacy = ParseObject('Pharmacy');
  pharmacy.set('user_id', user);
  pharmacy.set('name', pharmacyName);
  pharmacy.set('phone', pharmacyPhone);
  pharmacy.set('addr', pharmacyAddr);
  pharmacy.set('city', pharmacyCity);
  pharmacy.set('state', pharmacyState);
  pharmacy.set('zip', pharmacyZip);
  return await pharmacy.save();
}