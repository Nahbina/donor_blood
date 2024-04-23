// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  final bool? success;
  final List<Event>? events;

  Events({
    this.success,
    this.events,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        success: json["success"],
        events: json["events"] == null
            ? []
            : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      );

  get message => null;

  Map<String, dynamic> toJson() => {
        "success": success,
        "events": events == null
            ? []
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class Event {
  final String? id;
  final String? eventName;
  final DateTime? eventDate;
  final String? eventLocation;
  final String? eventDescription;
  final String? eventTime;
  final String? userId;
  Event({
    this.id,
    this.eventName,
    this.eventDate,
    this.eventLocation,
    this.eventDescription,
    this.eventTime,
    this.userId,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        eventName: json["event_name"],
        eventDate: json["event_date"] == null
            ? null
            : DateTime.parse(json["event_date"]),
        eventLocation: json["event_location"],
        eventDescription: json["event_description"],
        eventTime: json["event_time"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_name": eventName,
        "event_date":
            "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
        "event_location": eventLocation,
        "event_description": eventDescription,
        "event_time": eventTime,
        "user_id": userId,
      };
}
