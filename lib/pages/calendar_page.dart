import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scd_tool/components/greeting_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/login_data.dart';
import '../models/app_data.dart';

/// The hove page which hosts the calendar
class CalendarPage extends StatefulWidget {
  /// Creates the home page to display the calendar widget.
  const CalendarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  bool get wantKeepAlive => !context.watch<AppData>().dailySymptomsLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AppData>().getDailySymptoms();
    context.read<AppData>().getUserInfo();
  }

  MeetingDataSource dataSource = MeetingDataSource([]);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, appData, child) {
      if (!appData.dailySymptomsLoaded && !appData.error) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Loading spinner
          ),
        );
      } else if (appData.error) {
        return const Text('Error: Failed to fetch saved daily symptoms');
      } else {
        dataSource = MeetingDataSource(_getDataSource(appData.dailySymptoms));
        return Scaffold(
            body: Column(
          children: [
            GreetingWidget(
                appData.userInfo['first_name'], Theme.of(context).primaryColor,
                () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SymptomsInput(dataSource: dataSource);
                  });
            }),
            Expanded(
                child: Container(
                    margin: EdgeInsets.all(15),
                    // padding: EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(
                    //     color: Colors.black87,
                    //     width: 2
                    //   ),
                    //   color: Colors.white
                    // ),
                    child: SfCalendar(
                        view: CalendarView.month,
                        selectionDecoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          shape: BoxShape.rectangle,
                        ),
                        todayHighlightColor: Theme.of(context).primaryColor,
                        // headerHeight: 30,
                        headerStyle: CalendarHeaderStyle(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        onTap: (calendarTapDetails) {
                          List<Widget> body = [];
                          if (calendarTapDetails.appointments!.isEmpty) {
                            return;
                            // body.add(const SizedBox(
                            //     height: 100,
                            //     child: Center(
                            //         child: Text("No Symptoms Recorded"))));
                          } else {
                            var symptoms =
                                calendarTapDetails.appointments?.last.content;

                            List<Widget> chips = [];

                            for (var symptom in symptoms.entries) {
                              chips.add(InputChip(
                                  selectedColor:
                                      Theme.of(context).colorScheme.primary,
                                  checkmarkColor: Colors.white,
                                  label: Text(
                                      symptom.key.replaceAll(RegExp(r'_'), ' '),
                                      style: TextStyle(
                                          color: symptom.value.toString() !=
                                                      "null" &&
                                                  symptom.value.toString() !=
                                                      "false"
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                  onSelected: (value) {},
                                  selected:
                                      symptom.value.toString() != "null" &&
                                          symptom.value.toString() !=
                                              "false") as Widget);
                            }

                            body.add(Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Center(
                                    child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 5.0,
                                  runSpacing: 5.0,
                                  children: chips,
                                ))));
                            print(symptoms);
                          }

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                    surfaceTintColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    title: Text(
                                        DateFormat('MMMM d, yyyy')
                                            .format(calendarTapDetails.date!),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    // surfaceTintColor: Theme.of(context).colorScheme.background,
                                    children: body);
                              });
                        },
                        monthCellBuilder: (BuildContext buildContext,
                            MonthCellDetails details) {
                          final Color backgroundColor =
                              _getMonthCellBackgroundColor(details);
                          final Color borderColor = _getMonthCellBorderColor(
                              details, backgroundColor);
                          final Color defaultColor =
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black54
                                  : Colors.white;
                          return Container(
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                border:
                                    Border.all(color: borderColor, width: 3),
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                details.date.day.toString(),
                                style: TextStyle(
                                    color: _getCellTextColor(backgroundColor),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                        dataSource: dataSource,
                        // by default the month appointment display mode set as Indicator, we can
                        // change the display mode as appointment using the appointment display
                        // mode property
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.none,
                          showAgenda: false,
                          showTrailingAndLeadingDates: false,
                        )))),
          ],
        ));
      }
    });
  }

  List<DailyReport> _getDataSource(List<Map<String, dynamic>> dailySymptoms) {
    List<DailyReport> reports = dailySymptoms.map((report) {
      var date = DateTime.parse(report["date"]);
      Map<String, dynamic> content = Map.from(report);

      content.remove("date");
      content.remove("user_id");

      return DailyReport(date, content);
    }).toList();
    return reports;
  }

  Color _getMonthCellBackgroundColor(dateDetails) {
    // if(dataSource.appointments != null){
    //   for(var appointment in dataSource.appointments!){
    //     if(appointment.date == dateDetails.date) return Theme.of(context).colorScheme.primary;
    //   }
    // }
    if (dateDetails.appointments.length == 1) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onBackground;
  }

  Color _getMonthCellBorderColor(dateDetails, backgroundColor) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (dateDetails.date == today) {
      // return Theme.of(context).primaryColor;
      return Colors.black;
    }
    return backgroundColor;
  }

  Color _getCellTextColor(backgroundColor) {
    if (backgroundColor == Theme.of(context).primaryColor) return Colors.white;
    if (backgroundColor == Theme.of(context).colorScheme.background)
      return Theme.of(context).colorScheme.onBackground;
    return Colors.white;
  }
}

class SymptomsInput extends StatefulWidget {
  final MeetingDataSource dataSource;

  const SymptomsInput({super.key, required this.dataSource});

  @override
  State<SymptomsInput> createState() => _SymptomsInputState();
}

class _SymptomsInputState extends State<SymptomsInput> {
  var states = {
    "fever": false,
    "chest_pain": false,
    "coughing": false,
    "shortness_of_breath": false,
    "fatigue": false,
    "swelling": false,
    "jaundice": false,
    "numbness": false,
    "confusion": false,
    "priapism": false
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> inputChips = states.keys.map((option) {
      return InputChip(
          selectedColor: Theme.of(context).colorScheme.primary,
          checkmarkColor: Colors.white,
          label: Text(option.replaceAll(RegExp(r'_'), ' '),
              style: TextStyle(
                  color: states[option]!
                      ? Colors.white
                      : Theme.of(context).colorScheme.onBackground)),
          onSelected: (selected) =>
              setState(() => states[option] = !states[option]!),
          selected: states[option]!) as Widget;
    }).toList();

    Widget button =
        TextButton(onPressed: submitSymptoms, child: Text("Submit"));

    return SimpleDialog(
      surfaceTintColor: Theme.of(context).colorScheme.background,
      title: const Text("Are you experiencing any of the following?",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          )),
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                runSpacing: 5.0,
                children: inputChips,
              ),
              Container(padding: const EdgeInsets.only(top: 20), child: button)
            ]))
      ],
    );
  }

  Future<void> submitSymptoms() async {
    String cookie = context.read<LoginData>().getCookie();
    final response = await http.put(
        Uri.parse(
            'https://scd-tool-api.onrender.com/user/current/daily-symptoms'),
        headers: {'Cookie': cookie, 'Content-Type': 'application/json'},
        body: jsonEncode(states));

    if (response.statusCode == 201) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Request successful');
      if (mounted) {
        // print(widget.dataSource.appointments);
        widget.dataSource.addReport(DailyReport(DateTime.now(), states));
        Navigator.pop(context);
        await context.read<AppData>().getDailySymptoms();
      }
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
      throw Exception('Failed to save symptoms');
    }
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<DailyReport> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  void addReport(DailyReport report) {
    appointments?.add(report);
    notifyListeners(CalendarDataSourceAction.add, [report]);
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class DailyReport {
  /// Creates a meeting class with required details.
  DailyReport(this.date, this.content);

  /// From which is equivalent to start time property of [Appointment].
  DateTime date;

  Map<String, dynamic> content;

  @override
  String toString() {
    return date.toString() + content.toString();
  }
}
