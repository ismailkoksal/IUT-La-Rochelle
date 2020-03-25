// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

List<Event> eventFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
  String uid;
  Description description;
  String summary;
  String location;
  String dtstart;
  String dtend;

  Event({
    this.uid,
    this.description,
    this.summary,
    this.location,
    this.dtstart,
    this.dtend,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        uid: json["uid"],
        description: Description.fromJson(json["description"]),
        summary: json["summary"],
        location: json["location"],
        dtstart: json["dtstart"],
        dtend: json["dtend"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "description": description.toJson(),
        "summary": summary,
        "location": location,
        "dtstart": dtstart,
        "dtend": dtend,
      };
}

class Description {
  String salle;
  String prof;
  String spe;

  Description({
    this.salle,
    this.prof,
    this.spe,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        salle: json["Salle"],
        prof: json["Prof"],
        spe: json["Spe"],
      );

  Map<String, dynamic> toJson() => {
        "Salle": salle,
        "Prof": prof,
        "Spe": spe,
      };
}
