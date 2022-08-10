library animate_countdown_text;

import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import 'countdown_format.dart';

part 'animate_unit.dart';

part 'animation_type.dart';

part "duration_format.dart";

part 'extensions.dart';

///
///@author shaw
///@date 2021/4/12
///@desc
///

typedef FormatDuration = DurationFormat Function(Period duration);
typedef AnimationBuilder = Widget Function(
    Widget child, String? preCharacter, String character);

class AnimateCountdownText extends StatefulWidget {
  static const STYLE_SINGLE_LINE = 1;
  static const STYLE_WITH_UNIT = 0;

  AnimateCountdownText(
      {Key? key,
      this.animationType = AnimationType.evaporation,
      this.characterTextStyle = const TextStyle(),
      this.suffixTextStyle = const TextStyle(),
      this.interval = const Duration(seconds: 1),
      this.earlierSeconds = 0,
      this.onDone,
      this.onExpired,
      this.style = STYLE_WITH_UNIT,
      this.characterPadding = const EdgeInsets.all(1),
      this.animationBuilder,
      this.countdownFormat,
      required this.targetTime})
      : assert(!interval.isNegative && interval != Duration.zero,
            "Interval must positive"),
        super(key: key);

  /// Build-in animation type, will ignore this if [animationBuilder] is provided
  final AnimationType animationType;

  /// Character TextStyle
  final TextStyle characterTextStyle;

  /// Suffix TextStyle
  final TextStyle suffixTextStyle;

  /// Interval to refresh view, default to 1 second
  final Duration interval;

  final int style;

  /// 提前几秒触发onDone, 默认0
  final int earlierSeconds;

  final VoidCallback? onDone;
  final VoidCallback? onExpired;

  /// Padding of characters
  final EdgeInsets characterPadding;

  /// Custom animation
  final AnimationBuilder? animationBuilder;

  final DateTime targetTime;
  final CountdownFormat? countdownFormat;

  @override
  _AnimateCountdownTextState createState() => _AnimateCountdownTextState();
}

class _AnimateCountdownTextState extends State<AnimateCountdownText> {
  late Period timeLeft;
  late final Stream<DurationFormat> _durationFormatStream;
  late DurationFormat _initDurationFormat;
  StreamSubscription? subscription;
  CountdownFormat? countdownFormat;
  PeriodUnits? periodUnits;
  DateTime dateTime = DateTime.now();
  bool onDoneTriggered = false;

  @override
  void initState() {
    super.initState();
    _durationFormatStream =
        Stream<DurationFormat>.periodic(widget.interval, (_) {
      _updateTimeLeft();
      if (widget.onDone != null) {
        if (timeLeft.toTime().inSeconds <= 0 &&
            timeLeft.toTime().inSeconds.abs() <= widget.earlierSeconds) {
          if (!onDoneTriggered) {
            widget.onDone!.call();
          }
          onDoneTriggered = true;
        } else {
          onDoneTriggered = false;
        }
      }
      //倒计时过期
      if (widget.onExpired != null) {
        if (timeLeft.toTime().inSeconds < 0) {
          // logger.d(
          //     "${DateTime.now().timeZoneOffset}-${LocalDateTime.now()}-${LocalDateTime.dateTime(widget.targetTime)}");
          widget.onExpired!.call();
        }
      }

      return _formatYMDHMS(timeLeft);
    }).asBroadcastStream(onCancel: (subscription) => subscription.cancel());
    _init();
    subscription = _durationFormatStream.listen((format) {
      if (!_initDurationFormat.sameFormatWith(format)) {
        _refreshInitDurationFormat(format);
      }
    });
  }

  DurationFormat _formatYMDHMS(Period period) {
    return DurationFormat(
      year: countdownFormat!.showYear ? "${period.years.abs()}" : null,
      yearSuffix: "年",
      month: countdownFormat!.showMonth ? "${period.months.abs()}" : null,
      monthSuffix: "月",
      week: countdownFormat!.showWeek ? "${period.weeks.abs()}" : null,
      weekSuffix: "周",
      day: countdownFormat!.showDay ? "${period.days.abs()}" : null,
      daySuffix: "日",
      hour: countdownFormat!.showHour ? "${period.hours.abs()}" : null,
      hourSuffix: "时",
      minute: countdownFormat!.showMinute ? "${period.minutes.abs()}" : null,
      minuteSuffix: "分",
      second: countdownFormat!.showSecond ? "${period.seconds.abs()}" : null,
      secondSuffix: "秒",
    );
  }

  @override
  void didUpdateWidget(covariant AnimateCountdownText oldWidget) {
    if (oldWidget.targetTime != widget.targetTime ||
        oldWidget.animationType != widget.animationType ||
        oldWidget.interval != widget.interval) {
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    _updateTimeLeft();

    // _checkAndHandleTimeUp();

    _initDurationFormat = _formatYMDHMS(timeLeft);
  }

  _updateTimeLeft() {
    dateTime = widget.targetTime;

    countdownFormat = widget.countdownFormat ?? CountdownFormat.getDefault();
    timeLeft = differenceBetweenDateTime(dateTime,
        periodUnits: countdownFormat!.toPeriodUnits());
    // timeLeft = PeriodUtil.differenceBetweenDateTime(dateTime,
    //     periodUnits: countdownFormat!.toPeriodUnits());
    // timeLeft = period;
  }

  static Period differenceBetweenDateTime(DateTime end,
      {DateTime? start, PeriodUnits periodUnits = PeriodUnits.seconds}) {
    if (Platform.isMacOS || Platform.isAndroid) {
      return Period.differenceBetweenDateTime(
          start == null ? LocalDateTime.now() : LocalDateTime.dateTime(start),
          LocalDateTime.dateTime(end),
          periodUnits);
    }
    return Period.differenceBetweenDateTime(
        start == null ? LocalDateTime.now() : LocalDateTime.dateTime(start),
        LocalDateTime.dateTime(end.subtract(DateTime.now().timeZoneOffset)),
        periodUnits);
  }

  _refreshInitDurationFormat(DurationFormat newDurationFormat) {
    if (!mounted) return;
    setState(() {
      _initDurationFormat = newDurationFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [];
    var sizedBox = const SizedBox(
      width: 16,
    );
    if (widget.style == AnimateCountdownText.STYLE_WITH_UNIT) {
      // Year
      if (countdownFormat!.showYear && _initDurationFormat.showYear) {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.year, _initDurationFormat.year!));
        if (_initDurationFormat.showYearSuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.yearSuffix!));
        }
        row.add(Column(
          children: column,
          mainAxisSize: MainAxisSize.min,
        ));
        row.add(sizedBox);
      }

      // Month
      if (countdownFormat!.showMonth && _initDurationFormat.showMonth) {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.month, _initDurationFormat.month!));
        if (_initDurationFormat.showMonthSuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.monthSuffix!));
        }
        row.add(Column(
          children: column,
          mainAxisSize: MainAxisSize.min,
        ));
        row.add(sizedBox);
      }

      // Week
      if (countdownFormat!.showWeek && _initDurationFormat.showWeek) {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.week, _initDurationFormat.week!));
        if (_initDurationFormat.showWeek) {
          column.add(_buildSuffixItem(_initDurationFormat.weekSuffix!));
        }
        row.add(Column(
          children: column,
          mainAxisSize: MainAxisSize.min,
        ));
        row.add(sizedBox);
      }

      // Day
      if (countdownFormat!.showDay && _initDurationFormat.showDay) {
        List<Widget> column = [];
        column.add(
            _buildAnimateUnit((event) => event?.day, _initDurationFormat.day!));
        if (_initDurationFormat.showDaySuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.daySuffix!));
        }
        row.add(Column(
          children: column,
          mainAxisSize: MainAxisSize.min,
        ));
        row.add(sizedBox);
      }

      // Hour
      if (countdownFormat!.showHour && _initDurationFormat.hour != '0') {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.hour, _initDurationFormat.hour!));
        if (_initDurationFormat.showHourSuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.hourSuffix!));
        }
        row.add(Column(
          mainAxisSize: MainAxisSize.min,
          children: column,
        ));
        row.add(sizedBox);
      }

      // Minute
      if (countdownFormat!.showMinute && _initDurationFormat.minute != '0') {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.minute, _initDurationFormat.minute!));
        if (_initDurationFormat.showMinuteSuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.minuteSuffix!));
        }
        row.add(Column(
          children: column,
          mainAxisSize: MainAxisSize.min,
        ));
        row.add(sizedBox);
      }
      // Second
      if (countdownFormat!.showSecond) {
        List<Widget> column = [];
        column.add(_buildAnimateUnit(
            (event) => event?.second, _initDurationFormat.second!));
        if (_initDurationFormat.showSecondSuffix) {
          column.add(_buildSuffixItem(_initDurationFormat.secondSuffix!));
        }
        row.add(Column(
          mainAxisSize: MainAxisSize.min,
          children: column,
        ));
        row.add(sizedBox);
      }
    } else {
      // Year
      if (countdownFormat!.showYear && _initDurationFormat.showYear) {
        row.add(_buildAnimateUnit(
            (event) => event?.year, _initDurationFormat.year!));
        row.add(Text(":", style: widget.characterTextStyle));
      }

      // Month
      if (countdownFormat!.showMonth && _initDurationFormat.showMonth) {
        row.add(_buildAnimateUnit(
            (event) => event?.month, _initDurationFormat.month!));
        row.add(Text(":", style: widget.characterTextStyle));
      }

      // Week
      if (countdownFormat!.showWeek && _initDurationFormat.showWeek) {
        row.add(_buildAnimateUnit(
            (event) => event?.week, _initDurationFormat.week!));
        row.add(Text(":", style: widget.characterTextStyle));
      }

      // Day
      if (countdownFormat!.showDay && _initDurationFormat.showDay) {
        row.add(
            _buildAnimateUnit((event) => event?.day, _initDurationFormat.day!));
        row.add(Text(":", style: widget.characterTextStyle));
      }

      // Hour
      if (countdownFormat!.showHour && _initDurationFormat.hour != '0') {
        row.add(_buildAnimateUnit(
            (event) => event?.hour, _initDurationFormat.hour!));
        row.add(Text(":", style: widget.characterTextStyle));
      }

      // Minute
      if (countdownFormat!.showMinute) {
        row.add(_buildAnimateUnit((event) => event?.minute?.padLeft(2, "0"),
            _initDurationFormat.minute!));
        row.add(Text(":", style: widget.characterTextStyle));
      }
      // Second
      if (countdownFormat!.showSecond) {
        row.add(_buildAnimateUnit((event) => event?.second?.padLeft(2, "0"),
            _initDurationFormat.second!));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: row,
    );
  }

  /// Animate content
  _buildAnimateUnit(
      String? Function(DurationFormat?) streamConvert, String initValue) {
    return AnimateUnit(
        itemStream: _durationFormatStream.map(streamConvert),
        initValue: initValue.length == 1 ? "0$initValue" : initValue,
        textStyle: widget.characterTextStyle,
        animationType: widget.animationType,
        padding: widget.characterPadding,
        animationBuilder: widget.animationBuilder);
  }

  /// Suffix
  _buildSuffixItem(String suffix) {
    return Text(suffix, style: widget.suffixTextStyle);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
