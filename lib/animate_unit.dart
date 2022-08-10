part of "animate_countdown_text.dart";

class AnimateUnit<String> extends StatefulWidget {
  final Stream<String?> itemStream;
  final String initValue;
  final TextStyle textStyle;
  final AnimationType animationType;
  final AnimationBuilder? animationBuilder;
  final EdgeInsets padding;

  AnimateUnit(
      {Key? key,
      required this.itemStream,
      required this.initValue,
      required this.textStyle,
      required this.animationType,
      required this.padding,
      this.animationBuilder})
      : super(key: key);

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<AnimateUnit> with SingleTickerProviderStateMixin {
  // ignore: cancel_subscriptions
  StreamSubscription<String?>? _streamSubscription;
  late String? _currentValue;
  String? _preValue;
  final Duration _animationDuration = const Duration(milliseconds: 600);

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimateUnit oldWidget) {
    if (oldWidget.initValue != widget.initValue) {
      _streamSubscription?.cancel();
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  _init() {
    _currentValue = widget.initValue;
    _streamSubscription = widget.itemStream.distinct().listen((value) {
      _notifyValueChange(value);
    }) as StreamSubscription<String?>?;
  }

  _notifyValueChange(String? newValue) {
    if (mounted) {
      setState(() {
        _preValue = _currentValue;
        _currentValue = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentValue == null) return SizedBox();

    final widgets = <Widget>[];
    final strList = _currentValue!.split('');
    for (int i = 0; i < strList.length; i++) {
      final character = strList[i];
      widgets.add(Container(
          padding: widget.padding,
          alignment: Alignment.center,
          child: _buildAnimation(child: Text(character, style: widget.textStyle), character: character, index: i)));
    }
    return Row(
      children: widgets,
    );
  }

  _buildAnimation({required Widget child, required String character, required int index}) {
    String preCharacter = "";
    if (_preValue != null && _preValue!.length >= index + 1) {
      preCharacter = _preValue![index];
    }

    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(child, preCharacter, character);
    }

    switch (widget.animationType) {
      case AnimationType.fallDown:
        return Stack(
          children: [
            if (preCharacter.isNotEmpty && preCharacter != character)
              FadeOutDown(
                  key: ValueKey(preCharacter),
                  child: Text(preCharacter, style: widget.textStyle),
                  animate: true,
                  from: 10,
                  duration: const Duration(milliseconds: 200)),
            SlideInDown(key: ValueKey(character), child: child, from: 10, duration: _animationDuration)
          ],
        );
      case AnimationType.evaporation:
        return Stack(
          children: [
            if (preCharacter.isNotEmpty && preCharacter != character)
              FadeOutUp(
                  key: ValueKey(preCharacter),
                  child: Text(preCharacter, style: widget.textStyle),
                  from: 15,
                  animate: true,
                  duration: _animationDuration),
            FadeIn(key: ValueKey(character), duration: _animationDuration, child: child)
          ],
        );
      case AnimationType.bounceIn:
        return BounceInUp(key: ValueKey(character), child: child, from: 10, duration: _animationDuration);
      case AnimationType.flipInX:
        return FlipInX(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.flipInY:
        return FlipInY(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.dance:
        return Dance(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.specialIn:
        return JelloIn(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.spinPerfect:
        return SpinPerfect(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.pulse:
        return Pulse(key: ValueKey(character), child: child, duration: _animationDuration);
      case AnimationType.none:
        return child;
      case AnimationType.zoomIn:
        return ZoomIn(key: ValueKey(character), child: child, duration: _animationDuration);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
