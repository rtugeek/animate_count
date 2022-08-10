// Flutter imports:
import 'package:time_machine/time_machine.dart';

const String YEAR = "Y";
const String MONTH = "M";
const String WEEK = "W";
const String DAY = "D";
const String HOUR = "H";
const String MINUTE = "m";
const String SECOND = "s";
const String MIRCOSECOND = "c";
const String FULL = "YMWDHmsc";
const List COUNTDOWN_FORMAT_LIST = [
  YEAR,
  MONTH,
  WEEK,
  DAY,
  HOUR,
  MINUTE,
  SECOND,
  MIRCOSECOND
];

class CountdownFormat {
  static const DEFAULT = "YMDHms";
  bool showYear;
  bool showMonth;
  bool showWeek;
  bool showDay;
  bool showHour;
  bool showMinute;
  bool showSecond;
  bool showMillisecond;

  CountdownFormat({
    this.showYear = false,
    this.showMonth = false,
    this.showWeek = false,
    this.showDay = false,
    this.showHour = false,
    this.showMinute = false,
    this.showSecond = false,
    this.showMillisecond = false,
  });

  static final CountdownFormat mDefault = CountdownFormat.getDefault();

  factory CountdownFormat.getDefault() {
    CountdownFormat countdownFormat = CountdownFormat();
    countdownFormat
      ..showYear = true
      ..showDay = true
      ..showWeek = false
      ..showMinute = true
      ..showHour = true
      ..showSecond = true
      ..showMonth = false;
    return countdownFormat;
  }

  factory CountdownFormat.getFull() {
    CountdownFormat countdownFormat = CountdownFormat();
    countdownFormat
      ..showYear = true
      ..showMonth = true
      ..showWeek = true
      ..showDay = true
      ..showHour = true
      ..showMinute = true
      ..showSecond = true
      ..showMillisecond = true;
    return countdownFormat;
  }

  factory CountdownFormat.getDaysOnly() {
    CountdownFormat countdownFormat = CountdownFormat();
    countdownFormat.showDay = true;
    return countdownFormat;
  }

  List<bool> toBoolList() {
    var list = <bool>[];
    list.add(showYear);
    list.add(showMonth);
    list.add(showWeek);
    list.add(showDay);
    list.add(showHour);
    list.add(showMinute);
    list.add(showSecond);
    list.add(showMillisecond);
    return list;
  }

  bool isShow(String? unit) {
    if (unit == YEAR) {
      return showYear;
    }
    if (unit == MONTH) {
      return showMonth;
    }
    if (unit == WEEK) {
      return showWeek;
    }
    if (unit == DAY) {
      return showDay;
    }
    if (unit == HOUR) {
      return showHour;
    }
    if (unit == MINUTE) {
      return showMinute;
    }
    if (unit == SECOND) {
      return showSecond;
    }
    if (unit == MIRCOSECOND) {
      return showMillisecond;
    }
    return true;
  }

  static CountdownFormat fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return CountdownFormat.getDefault();
    }
    return CountdownFormat(
      showYear: map['showYear'] ?? false,
      showMonth: map['showMonth'] ?? false,
      showWeek: map['showWeek'] ?? false,
      showDay: map['showDay'] ?? false,
      showHour: map['showHour'] ?? false,
      showMinute: map['showMinute'] ?? false,
      showSecond: map['showSecond'] ?? false,
      showMillisecond: map['showMillisecond'] ?? false,
    );
  }

  Map<String, bool> toMap() {
    Map<String, bool> map = {
      'showYear': showYear,
      'showMonth': showMonth,
      'showWeek': showWeek,
      'showDay': showDay,
      'showHour': showHour,
      'showMinute': showMinute,
      'showSecond': showSecond,
      'showMillisecond': showMillisecond
    };
    return map;
  }

  @override
  String toString() {
    return formatListToString(toBoolList());
  }

  static String formatListToString(List<bool> list) {
    var stringBuffer = StringBuffer("");
    for (var i = 0; i < list.length; i++) {
      if (list[i]) {
        stringBuffer.write(COUNTDOWN_FORMAT_LIST[i]);
      }
    }
    return stringBuffer.toString();
  }

  static CountdownFormat fromString(String? str) {
    if (str?.isEmpty == true) {
      return CountdownFormat.getDefault();
    }

    CountdownFormat countdownFormat = CountdownFormat();

    if (str!.contains(YEAR)) {
      countdownFormat.showYear = true;
    }

    if (str.contains(MONTH)) {
      countdownFormat.showMonth = true;
    }

    if (str.contains(WEEK)) {
      countdownFormat.showWeek = true;
    }

    if (str.contains(DAY)) {
      countdownFormat.showDay = true;
    }

    if (str.contains(HOUR)) {
      countdownFormat.showHour = true;
    }

    if (str.contains(MINUTE)) {
      countdownFormat.showMinute = true;
    }

    if (str.contains(SECOND)) {
      countdownFormat.showSecond = true;
    }

    if (str.contains(MIRCOSECOND)) {
      countdownFormat.showMillisecond = true;
    }

    return countdownFormat;
  }

  PeriodUnits toPeriodUnits() {
    List<PeriodUnits> units = [];
    if (showYear) {
      units.add(PeriodUnits.years);
    }
    if (showMonth) {
      units.add(PeriodUnits.months);
    }
    if (showWeek) {
      units.add(PeriodUnits.weeks);
    }
    if (showDay) {
      units.add(PeriodUnits.days);
    }
    if (showHour) {
      units.add(PeriodUnits.hours);
    }
    if (showMinute) {
      units.add(PeriodUnits.minutes);
    }
    if (showSecond) {
      units.add(PeriodUnits.seconds);
    }

    if (showMillisecond) {
      units.add(PeriodUnits.milliseconds);
    }
    return PeriodUnits.union(units);
  }
}
