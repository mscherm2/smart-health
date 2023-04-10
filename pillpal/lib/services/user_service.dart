import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<ParseUser?> getUser() async {
  ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  return currentUser;
}

Future<ParseObject?> getDoctor() async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Doctor'));
  // `whereContains` is a basic query method that checks if string field
  // contains a specific substring
  final ParseUser? currentUser = await getUser();

  parseQuery.whereContains('user_id', currentUser?.get('objectId'));

  // The query will resolve only after calling this method, retrieving
  // an array of `ParseObjects`, if success
  final ParseResponse apiResponse = await parseQuery.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      return (o as ParseObject);
    }
  }
  return null;
}

Future<ParseObject?> getPharmacy() async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Pharmacy'));
  // `whereContains` is a basic query method that checks if string field
  // contains a specific substring
  final ParseUser? currentUser = await getUser();

  parseQuery.whereContains('user_id', currentUser?.get('objectId'));

  // The query will resolve only after calling this method, retrieving
  // an array of `ParseObjects`, if success
  final ParseResponse apiResponse = await parseQuery.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      return (o as ParseObject);
    }
  }
  return null;
}