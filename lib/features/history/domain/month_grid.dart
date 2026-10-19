/// Cells of a month calendar, week rows starting on [firstDayOfWeek]
/// (ISO 1–7). `null` = padding before the 1st / after the last day.
List<DateTime?> monthGrid(int year, int month, {required int firstDayOfWeek}) {
  final first = DateTime(year, month);
  final days = DateTime(year, month + 1, 0).day;
  final leading = (first.weekday - firstDayOfWeek + 7) % 7;
  final cells = <DateTime?>[
    for (var i = 0; i < leading; i++) null,
    for (var day = 1; day <= days; day++) DateTime(year, month, day),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return cells;
}

/// ISO weekdays in display order (e.g. Mon…Sun or Sun…Sat).
List<int> weekdayOrder(int firstDayOfWeek) => [
  for (var i = 0; i < 7; i++) (firstDayOfWeek - 1 + i) % 7 + 1,
];

DateTime dayOf(DateTime moment) {
  final local = moment.toLocal();
  return DateTime(local.year, local.month, local.day);
}
