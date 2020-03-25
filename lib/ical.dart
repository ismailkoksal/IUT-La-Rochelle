import 'dart:convert';

class ICAL {
  static const BEGIN = 'BEGIN';
  static const END = 'END';
  static const VEVENT = 'VEVENT';
  static const UID = 'UID';
  static const DTSTART = 'DTSTART'; // Date de début de l'événement
  static const DTEND = 'DTEND'; // Date de fin de l'événement
  static const SUMMARY = 'SUMMARY'; // Titre de l'événement
  static const LOCATION = 'LOCATION'; // Lieu de l'événement
  static const DESCRIPTION = 'DESCRIPTION'; // Description de l'événement

  static String icsToJson(String iCalendar) {
    final events = [];
    var currentEvent = {};

    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(iCalendar);

    for (String line in lines) {
      final lineData = line.split(':');
      var key = lineData[0];
      var value = lineData.sublist(1).join(':');

      if (key.contains(';')) {
        final keyParts = key.split(';');
        key = keyParts[0];
      }

      /*description(String v) {
        var currentObj = {};
        String desc = v;

        String salle = desc.substring(0, desc.indexOf('Prof') - 1);
        String prof = desc.substring(
            desc.indexOf(salle) + salle.length + 1, desc.indexOf('Spe') - 1);
        String spe = desc.substring(
            desc.indexOf(prof) + prof.length + 1, desc.indexOf('\\'));

        List<String> salleList = salle.split(':');
        String salleKey = salleList[0];
        String salleValue = salleList[1];

        List<String> profList = prof.split(':');
        String profKey = profList[0];
        String profValue = profList[1];

        List<String> speList = spe.split(':');
        String speKey = speList[0];
        String speValue = speList.sublist(1).join(':');

        currentObj[salleKey] = salleValue;
        currentObj[profKey] = profValue;
        currentObj[speKey] = speValue;

        return currentObj;

        print('[$salleKey:$salleValue]');
        print('[$profKey:$profValue]');
        print('[$speKey:$speValue]');
      }*/

      description(v) {
        String desc = v;
        print(desc);

        final pattern = RegExp(
            r'Salle:(?<Salle>.*) Prof:(?<Prof>.*) Spe:(?<Spe>.*)\\.*\\.*');

        final match = pattern.firstMatch(desc);
        final map = {
          'Salle': match.namedGroup('Salle'),
          'Prof': match.namedGroup('Prof'),
          'Spe': Uri.decodeFull(match.namedGroup('Spe').replaceAll('=', '%'))
        };

        print(map);
        return map;

        final list = map;

        print(JsonEncoder.withIndent('  ').convert(list));
        return const JsonEncoder.withIndent('  ').convert(list);
      }

      switch (key) {
        case BEGIN:
          if (value == VEVENT) currentEvent = {};
          break;
        case UID:
          currentEvent['uid'] = value;
          break;
        case DESCRIPTION:
          currentEvent['description'] = description(value);
          break;
        case SUMMARY:
          currentEvent['summary'] = value;
          break;
        case LOCATION:
          currentEvent['location'] = value;
          break;
        case DTSTART:
          currentEvent['dtstart'] = value;
          break;
        case DTEND:
          currentEvent['dtend'] = value;
          break;
        case END:
          if (value == VEVENT) events.add(currentEvent);
          break;
      }
    }
    return json.encode(events);
  }
}
