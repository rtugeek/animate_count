part of "animate_countdown_text.dart";

///
///@author shaw
///@date 2021/4/14
///@desc Extensions
///
extension DurationExt on Duration {
  /// Year Month Day in human words
  List<int> calculateYMDDistance({required bool reverse}) {
    DateTime now = DateTime.now().toUtc();
    DateTime to = reverse ? now.subtract(this) : now.add(this);
    DateTime start;
    DateTime end;
    bool negative = this.isNegative;

    if (now.isAtSameMomentAs(to)) return [0, 0, 0];

    if (now.isBefore(to)) {
      start = now;
      end = to;
    } else {
      start = to;
      end = now;
    }
    var distYear = end.year - start.year;
    var distMonth = end.month - start.month;
    var distDay = end.day - start.day;
    if (distDay < 0) {
      distMonth--;
      if (distMonth < 0) {
        distYear--;
        distMonth = end.month + 12 - start.month - 1;
      }
      distDay = end.day + (start.daysOfMonth - start.day);
    } else if (distMonth < 0) {
      distYear--;
      distMonth = end.month + 12 - start.month;
    }
    return negative ? [-distYear, -distMonth, -distDay] : [distYear, distMonth, distDay];
  }

  /// Year Month Day Hour Minute Second in human words
  List<int> calculateYMDHMSDistance({required bool reverse}) {
    final ymdList = this.calculateYMDDistance(reverse: reverse);
    ymdList.add(this._hoursDistance);
    ymdList.add(this._minutesDistance);
    ymdList.add(this._secondsDistance);
    return ymdList;
  }

  /// Day Hour Minute Second
  List<int> calculateDHMSDistance() {
    int distDay = this.inDays;
    int disHour = this._hoursDistance;
    int disMinute = this._minutesDistance;
    int disSecond = this._secondsDistance;
    return [distDay, disHour, disMinute, disSecond];
  }

  int get _hoursDistance =>
      this.inHours.isNegative ? -(this.inHours.abs() % Duration.hoursPerDay) : this.inHours % Duration.hoursPerDay;

  int get _minutesDistance =>
      this.inMinutes.isNegative ? -(this.inMinutes.abs() % Duration.minutesPerHour) : this.inMinutes % Duration.minutesPerHour;

  int get _secondsDistance => this.inSeconds.isNegative
      ? -(this.inSeconds.abs() % Duration.secondsPerMinute)
      : this.inSeconds % Duration.secondsPerMinute;
}

extension on DateTime {
  /// return day count of month
  int get daysOfMonth {
    if (month == 2) {
      if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
        // leap
        return 29;
      }
      return 28;
    }
    if ([1, 3, 5, 7, 8, 10, 12].contains(month)) {
      return 31;
    }
    return 30;
  }
}
