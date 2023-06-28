import 'package:flutter/material.dart';

class SAText extends StatelessWidget {
  const SAText({
    required this.text,
    this.style,
    super.key,
  });

  const factory SAText.timePicker({
    required String text,
  }) = _TimePicker;

  const factory SAText.calendarSchedule({
    required String text,
    required TextStyle style,
    int maxLines,
  }) = _CalendarSchedule;

  const factory SAText.appBarTitle({
    required String text,
    TextStyle style,
  }) = _AppBarTitle;

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

class _AppBarTitle extends SAText {
  const _AppBarTitle({
    required super.text,
    super.style,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      style: textTheme.titleLarge!.copyWith(
        color: colorScheme.secondary,
      ),
    );
  }
}

class _CalendarSchedule extends SAText {
  const _CalendarSchedule({
    required super.text,
    required super.style,
    this.maxLines,
  });

  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: style!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      maxLines: maxLines,
    );
  }
}

class _TimePicker extends SAText {
  const _TimePicker({
    required super.text,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      textAlign: TextAlign.justify,
      style: textTheme.labelLarge!.copyWith(
        color: colorScheme.secondaryContainer,
      ),
    );
  }
}
