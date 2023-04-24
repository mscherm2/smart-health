import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../services/doctor_service.dart';
import '../services/pharmacy_service.dart';
import '../utils/message.dart';
import 'UserPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerDoctorName = TextEditingController();
  final controllerDoctorPhone = TextEditingController();
  final controllerDoctorEmail = TextEditingController();
  final controllerDoctorOther = TextEditingController();
  final controllerPharmacyName = TextEditingController();
  final controllerPharmacyPhone = TextEditingController();
  final controllerPharmacyStreetAddress = TextEditingController();
  final controllerPharmacyCity = TextEditingController();
  final controllerPharmacyState = TextEditingController();
  final controllerPharmacyZip = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('signup', style: TextStyle(fontSize: 24)).tr(),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                      'assets/images/large_logo.png'),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('userregistration',
                      style: TextStyle(fontSize: 20)).tr(),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerUsername,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'username'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'email'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'password'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('Doctor Information',
                      style: TextStyle(fontSize: 20)).tr(),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerDoctorName,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'doctorname'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerDoctorPhone,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'doctorphone'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerDoctorEmail,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'doctoremail'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  minLines: 3, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: controllerDoctorOther,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'doctorotherinfo'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: const Text('Pharmacy Information',
                      style: TextStyle(fontSize: 20)).tr(),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: controllerPharmacyName,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacyname'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPharmacyPhone,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacyphone'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPharmacyStreetAddress,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacyaddr'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPharmacyCity,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacycity'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPharmacyState,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacystate'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPharmacyZip,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'pharmacyzip'.tr(),
                      labelStyle: TextStyle(fontSize: 20)
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('signup', style: TextStyle(fontSize: 20)).tr(),
                    onPressed: () => doUserRegistration(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: const Text('changelanguage', style: TextStyle(fontSize: 20)).tr(),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    height: 50,
                    child: DropdownButton<Locale>(
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Locale? value) {
                        context.setLocale(value!);
                      },
                      items: [
                        DropdownMenuItem<Locale>(
                          value: Locale('en', 'US'),
                          child: Text('english', style: TextStyle(fontSize: 20)).tr(),
                        ),
                        DropdownMenuItem<Locale>(
                          value: Locale('es', 'US'),
                          child: Text('spanish', style: TextStyle(fontSize: 20)).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    final doctorName = controllerDoctorName.text.trim();
    final doctorPhone = controllerDoctorPhone.text.trim();
    final doctorEmail = controllerDoctorEmail.text.trim();
    final doctorOther = controllerDoctorOther.text.trim();
    final pharmacyName = controllerPharmacyName.text.trim();
    final pharmacyPhone = controllerPharmacyPhone.text.trim();
    final pharmacyAddr = controllerPharmacyStreetAddress.text.trim();
    final pharmacyCity = controllerPharmacyCity.text.trim();
    final pharmacyState = controllerPharmacyState.text.trim();
    final pharmacyZip = controllerPharmacyZip.text.trim();

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      var doctorResponse = await createDoctor(doctorName, doctorPhone, doctorEmail, doctorOther);

      var pharmacyResponse = await createPharmacy(pharmacyName, pharmacyPhone, pharmacyAddr, pharmacyCity, pharmacyState, pharmacyZip);

      if (doctorResponse.success && pharmacyResponse.success) {
        Message.showSuccess(
            context: context,
            message: 'successful'.tr(),
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
                    (Route<dynamic> route) => false,
              );
            });
      }
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }
}
