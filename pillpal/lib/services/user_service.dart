import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<ParseUser?> getUser() async {
  ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  return currentUser;
}
/*
Future<String> getDoctor() async {
  final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Doctor'));
  // `whereContains` is a basic query method that checks if string field
  // contains a specific substring
  final ParseUser? currentUser = await getUser();
  parseQuery.whereContains('user_id', currentUser?.get('user_id'));

  // The query will resolve only after calling this method, retrieving
  // an array of `ParseObjects`, if success
  final ParseResponse apiResponse = await parseQuery.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      return ((o as ParseObject).toString());
    }
  }
}*/