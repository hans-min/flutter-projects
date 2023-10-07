import 'package:flutter/material.dart';
import 'package:myoty/utils/extension.dart';

/// If both `dateTime` and `dateTimeStr` is non-null, `dateTime`will be used
class DateTimeRichText extends StatelessWidget {
  const DateTimeRichText({
    this.dateTimeStr,
    this.dateTime,
    super.key,
    this.style,
    this.hasIcon = true,
  });
  final TextStyle? style;
  final String? dateTimeStr;
  final DateTime? dateTime;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    final str = dateTime != null
        ? dateTime!.formatToString()
        : dateTimeStr != null
            ? dateTimeStr!.iso8601ToString()
            : "Never updated";
    return RichTextSpan(
      defaultStyle: style,
      leading: hasIcon ? const Icon(Icons.access_time, size: 15) : null,
      text: " $str",
    );
  }
}

//Make robust widgets RichTextSpan and DatetimeRichText
class RichTextSpan extends StatelessWidget {
  const RichTextSpan({
    required this.text,
    super.key,
    this.defaultStyle,
    this.leading,
  });
  final TextStyle? defaultStyle;
  final Icon? leading;
  final String text;

  @override
  Widget build(BuildContext context) {
    //leading.color ??= color;
    return Text.rich(
      TextSpan(
        style: defaultStyle,
        children: [
          if (leading != null) WidgetSpan(child: leading!, style: defaultStyle),
          TextSpan(text: text)
        ],
      ),
    );
  }
}
