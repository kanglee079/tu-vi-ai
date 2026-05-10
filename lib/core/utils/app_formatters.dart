class AppFormatters {
  static const List<String> _weekdays = <String>[
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];

  static String fullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String monthRange(DateTime start, DateTime end) {
    return '${fullDate(start)} - ${fullDate(end)}';
  }

  static String weekday(DateTime date) => _weekdays[date.weekday - 1];
}
