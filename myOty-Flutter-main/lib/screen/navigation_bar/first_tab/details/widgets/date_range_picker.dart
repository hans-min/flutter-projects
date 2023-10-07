import 'package:flutter/material.dart';
import 'package:myoty/utils/extension.dart';

class DateRangePickerRow extends StatefulWidget {
  const DateRangePickerRow({
    required this.didGetDateRange,
    super.key,
  });
  final void Function(DateTimeRange) didGetDateRange;

  @override
  State<DateRangePickerRow> createState() => _DateRangePickerRowState();
}

class _DateRangePickerRowState extends State<DateRangePickerRow> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 365)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildDatePickerRow(context, "From: ", dateRange.start),
        buildDatePickerRow(context, "To: ", dateRange.end),
      ],
    );
  }

  Row buildDatePickerRow(BuildContext context, String text, DateTime time) {
    return Row(
      children: [
        Text(text),
        OutlinedButton(
          onPressed: () => showDateRangePickerPage(context),
          child: Text(
            time.formatToString(withTime: false),
          ),
        ),
      ],
    );
  }

  Future<void> showDateRangePickerPage(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
    });
    widget.didGetDateRange(newDateRange);
  }
}
