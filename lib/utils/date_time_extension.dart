extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: day == weekday
            ? DateTime.daysPerWeek
            : (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }

  DateTime previous(int day) {
    return subtract(
      Duration(
        days: day == weekday ? 7 : (weekday - day) % DateTime.daysPerWeek,
      ),
    );
  }
}
