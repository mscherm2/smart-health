import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// get method to get current user
Future<ParseUser?> getUser() async {
  ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  return currentUser;
}

// get method to get all medication objects for the current user
Future<List<ParseObject>> getMeds() async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Medication'));
  // `whereContains` is a basic query method that checks if string field
  // contains a specific substring
  final ParseUser? currentUser = await getUser();

  parseQuery.whereContains('user_id', currentUser?.get('objectId'));

  // The query will resolve only after calling this method, retrieving
  // an array of `ParseObjects`, if success
  final ParseResponse apiResponse = await parseQuery.query();

  List<ParseObject> results = <ParseObject>[];

  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  }
  else {
    results = [];
  }
  return results;
}

// post method to create new medication object
void createMed(name, desc, days, times, amt, doseCnt, pickedFile) async {
  final ParseUser? currentUser = await getUser();

  var newMedObj = ParseObject('Medication');
  newMedObj.set('Name', name);
  newMedObj.set('Desc', desc);
  newMedObj.set('days', days);
  newMedObj.set('Time', times); // this is an array of DateTime objects
  newMedObj.set('amt', amt);
  newMedObj.set('doseCount', doseCnt);
  newMedObj.set('user_id', currentUser);

  if (!pickedFile.contains('asset')) {
    ParseFileBase? parseFile;
    parseFile = ParseFile(File(pickedFile));
    await parseFile.save();
    newMedObj.set('Image', parseFile);
  }

  await newMedObj.save();
}

Future<List<ParseObject>> getMedById(id) async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Medication'));

  parseQuery.whereContains('objectId', id);

  // The query will resolve only after calling this method, retrieving
  // an array of `ParseObjects`, if success
  final ParseResponse apiResponse = await parseQuery.query();

  List<ParseObject> results = <ParseObject>[];

  if (apiResponse.success && apiResponse.results != null) {
    results = apiResponse.results as List<ParseObject>;
  }
  else {
    results = [];
  }
  return results;
}