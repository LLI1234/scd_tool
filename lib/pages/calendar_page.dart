import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// The hove page which hosts the calendar
class CalendarPage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const CalendarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.month,
      monthCellBuilder:
            (BuildContext buildContext, MonthCellDetails details) {
              final Color backgroundColor =
                  _getMonthCellBackgroundColor(details);
              final Color defaultColor =
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white;
              return Container(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    details.date.day.toString(),
                    // style: TextStyle(color: _getCellTextColor(backgroundColor)),
                  ),
                ),
                margin: const EdgeInsets.all(2),
              );
            },
      dataSource: MeetingDataSource(_getDataSource()),
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.none,
          showTrailingAndLeadingDates: false,)
    ));
  }

  List<DailyReport> _getDataSource() {
    final List<DailyReport> meetings = <DailyReport>[];
    final DateTime today = DateTime.now();
    meetings.add(DailyReport(
        today, const Color(0xFF0F8644)));
    return meetings;
  }

  Color _getMonthCellBackgroundColor(dateDetails) {
    print(dateDetails.appointments);
    return Colors.white;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<DailyReport> source) {
    appointments = source;
  }

  // @override
  // DateTime getStartTime(int index) {
  //   return _getMeetingData(index).from;
  // }

  // @override
  // DateTime getEndTime(int index) {
  //   return _getMeetingData(index).to;
  // }

  // @override
  // String getSubject(int index) {
  //   return _getMeetingData(index).eventName;
  // }

  // @override
  // Color getColor(int index) {
  //   return _getMeetingData(index).background;
  // }

  @override
  bool isAllDay(int index) {
    return true;
  }

  // Meeting _getMeetingData(int index) {
  //   final dynamic meeting = appointments![index];
  //   late final Meeting meetingData;
  //   if (meeting is Meeting) {
  //     meetingData = meeting;
  //   }

  //   return meetingData;
  // }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class DailyReport {
  /// Creates a meeting class with required details.
  DailyReport(this.date, this.background);

  /// From which is equivalent to start time property of [Appointment].
  DateTime date;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

}