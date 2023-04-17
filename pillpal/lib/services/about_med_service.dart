import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<ParseUser?> getUser() async {
  ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  return currentUser;
}

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