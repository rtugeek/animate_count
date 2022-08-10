part of 'animate_countdown_text.dart';

///
///@author shaw
///@date 2021/4/12
///@desc format of DateTime
///
class DurationFormat {
  const DurationFormat(
      {this.year,
      this.yearSuffix,
      this.month,
        this.week,
        this.weekSuffix,
      this.monthSuffix ,
      this.day,
      this.daySuffix ,
      this.hour,
      this.hourSuffix,
      this.minute,
      this.minuteSuffix,
      this.second,
      this.secondSuffix});

  final String? year;
  final String? yearSuffix;
  final String? month;
  final String? week;
  final String? monthSuffix;
  final String? weekSuffix;
  final String? day;
  final String? daySuffix;
  final String? hour;
  final String? hourSuffix;
  final String? minute;
  final String? minuteSuffix;
  final String? second;
  final String? secondSuffix;

  bool get showYear => (year?.isNotEmpty == true && year != '0');

  bool get showYearSuffix => yearSuffix?.isNotEmpty ?? false;

  bool get showMonth => month?.isNotEmpty == true && month != '0';

  bool get showWeek => week?.isNotEmpty == true && week != '0';

  bool get showMonthSuffix => monthSuffix?.isNotEmpty ?? false;

  bool get showDay => day?.isNotEmpty == true && day != '0';

  bool get showDaySuffix => daySuffix?.isNotEmpty ?? false;

  bool get showHour => hour?.isNotEmpty == true && hour != '0';

  bool get showHourSuffix => hourSuffix?.isNotEmpty ?? false;

  bool get showMinute => minute?.isNotEmpty == true && minute != '0';

  bool get showMinuteSuffix => minuteSuffix?.isNotEmpty ?? false;

  bool get showSecond => second?.isNotEmpty == true && second != '0';

  bool get showSecondSuffix => secondSuffix?.isNotEmpty ?? false;

  @override
  String toString() {
    return "${year ?? ''}${yearSuffix ?? ''}${month ?? ''}${monthSuffix ?? ''}${day ?? ''}${daySuffix ?? ''}${hour ?? ''}${hourSuffix ?? ''}${minute ?? ''}${minuteSuffix ?? ''}${second ?? ''}${secondSuffix ?? ''}";
  }

  bool sameFormatWith(DurationFormat? another) {
    if (another == null) return false;
    return showYear == another.showYear &&
        showYearSuffix == another.showYearSuffix &&
        showMonth == another.showMonth &&
        showMonthSuffix == another.showMonthSuffix &&
        showDay == another.showDay &&
        showDaySuffix == another.showDaySuffix &&
        showHour == another.showHour &&
        showHourSuffix == another.showHourSuffix &&
        showMinute == another.showMinute &&
        showMinuteSuffix == another.showMinuteSuffix &&
        showSecond == another.showSecond &&
        showSecondSuffix == another.showSecondSuffix;
  }
}
