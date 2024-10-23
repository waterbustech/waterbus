import 'package:intl/intl.dart';

class DateTimeHelper {
  static const List<int> dayCountMonth = [
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];

  static const List<String> listMonth = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static List<String> calendarTitle = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  String addZeroPrefix(number) =>
      '${'00'.substring(number.toString().length)}$number';

  List<List<DateTime>> getScheduleThisMonth({DateTime? dateTime}) {
    final inputDate = dateTime ?? DateTime.now();
    final thisMonth = inputDate.month;
    final thisYear = inputDate.year;
    int firstDayOfMonth = DateTime(inputDate.year, thisMonth).weekday;
    firstDayOfMonth = firstDayOfMonth + 1;
    if (firstDayOfMonth == 8) {
      firstDayOfMonth = 0;
    }
    final List<List<DateTime>> thisMonthList = [];
    int date = 1;
    while (date <= dayCountMonth[thisMonth - 1]) {
      final List<DateTime> week = [];
      for (int i = 1; i < 8; i++) {
        if (date == 1) {
          if (i < firstDayOfMonth) {
            week.add(
              DateTime(thisYear, thisMonth)
                  .subtract(Duration(days: firstDayOfMonth - i)),
            );
          } else {
            week.add(DateTime(thisYear, thisMonth, date));
            date++;
          }
        } else {
          if (date <= dayCountMonth[thisMonth - 1]) {
            week.add(DateTime(thisYear, thisMonth, date));
          } else {
            week.add(
              week[week.length - 1].add(const Duration(days: 1)),
            );
          }
          date++;
        }
      }
      thisMonthList.add(week);
    }

    return thisMonthList;
  }

  bool isEqualTwoDate(DateTime? date1, DateTime? date2) {
    return date1?.day == date2?.day &&
        date1?.month == date2?.month &&
        date1?.year == date2?.year;
  }

  bool locatedInThisMonth(DateTime date, {DateTime? compareDate}) {
    final DateTime compare = compareDate ?? DateTime.now();
    return date.month == compare.month;
  }

  String getDayName(DateTime date) {
    return calendarTitle[date.weekday - 1];
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));

    if (hours > 0) {
      return "${twoDigits(hours)}:$minutes:$secs";
    } else {
      return "$minutes:$secs";
    }
  }

  String formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('MMMM d, y');

    final timeFormat = DateFormat('HH:mm');

    final String formattedDate = dateFormat.format(dateTime);

    final String formattedTime = timeFormat.format(dateTime);

    return '$formattedDate | $formattedTime';
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
