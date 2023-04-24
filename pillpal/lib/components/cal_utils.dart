// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
/*final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final myEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_getMyEvents);*/

Map<String, List<String>> myEvents = HashMap();

final Future<List<NotificationModel>> futureListMyEvents = AwesomeNotifications().listScheduledNotifications();

var pastLength = 0;

// kEvents['2023-Apr-4'] = ['9:00AM - Advil', '11:00AM - Claritin', ]
// break NotificationModel down so

Future<void> generateEvents() async {
/* for event in listMyEvents:
      kEvents[event.schedule.toString().
      .payload!["name"]
      String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
 */

  List<NotificationModel> currEvents = await AwesomeNotifications().listScheduledNotifications();

  if (currEvents.length != pastLength) {
    myEvents = HashMap();
    print("HEY YA");
    currEvents.forEach((element) =>
    {
      addEvent(element.toMap())
    });
    pastLength = currEvents.length;
  }

}

void addEvent(Map<String, dynamic> event) {
  DateTime date = new DateTime(event["schedule"]["year"], event["schedule"]["month"], event["schedule"]["day"], event["schedule"]["hour"], event["schedule"]["minute"]);
  print(date);
  if (date != null) {
    if (myEvents[DateFormat('yyyy-MM-dd').format(date)] == null) {
      myEvents[DateFormat('yyyy-MM-dd').format(date)] = [];
    }
    String? n = event["content"]["payload"]["name"];
    myEvents[DateFormat('yyyy-MM-dd').format(date)]?.add(date.toString() + ' - ' + n!);
  }
}

/*final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });*/

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);