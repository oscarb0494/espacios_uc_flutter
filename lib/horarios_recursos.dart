import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:espacios_uc/app_theme.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:espacios_uc/model/Meeting.dart';
import 'package:espacios_uc/model/MeetingDataSource.dart';

class HorariosRecursosPage extends StatefulWidget {
  final int id;

  HorariosRecursosPage({required this.id});

  @override
  _HorariosRecursosPageState createState() =>
      _HorariosRecursosPageState(id: this.id);
}

class _HorariosRecursosPageState extends State<HorariosRecursosPage> {
  final int id;
  _HorariosRecursosPageState({required this.id});

  Map? data;
  Map? hData;
  List? recursosData;
  List? horariosData;
  List<DataRow>? filas;

  getRecursos() async {
    http.Response response = await http
        .get(Uri.parse("http://127.0.0.1:3000/recursos/getrecursos/$id"));

    data = json.decode(response.body);
    setState(() {
      recursosData = data!['recursos'];

      print(recursosData);
    });

    debugPrint(response.body);
  }

  List<DataRow> _createRows() {
    return recursosData!
        .map((recurso) => DataRow(cells: [
              DataCell(Text(recurso['nombre'])),
              DataCell(Text(recurso['estado'])),
              DataCell(Text(recurso['prestable'].toString()))
            ]))
        .toList();
  }

  getHorarios() async {
    http.Response response = await http
        .get(Uri.parse("http://127.0.0.1:3000/horario/gethorariosfinal/2"));

    hData = json.decode(response.body);
    setState(() {
      horariosData = hData!['horario'];
      print(horariosData);
    });

    debugPrint(response.body);
  }

  @override
  void initState() {
    super.initState();
    getRecursos();
    getHorarios();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_month)),
              Tab(icon: Icon(Icons.business_center)),
            ],
          ),
          title: Text('Materiales'),
        ),
        body: TabBarView(
          children: [
            Scaffold(
                body: SfCalendar(
              view: CalendarView.week,
              firstDayOfWeek: 1,
              timeSlotViewSettings: TimeSlotViewSettings(
                  startHour: 7,
                  endHour: 21,
                  nonWorkingDays: const <int>[DateTime.sunday]),
              dataSource: MeetingDataSource(_getDataSource(horariosData!)),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            )),
            DataTable(
              sortColumnIndex: 2,
              sortAscending: false,
              columns: [
                DataColumn(label: Text("Nombre")),
                DataColumn(label: Text("Estado")),
                DataColumn(label: Text("Prestable"), numeric: true),
              ],
              rows: _createRows(),
            )
          ],
        ),
      ),
    );
  }
}

List<Meeting> _getDataSource(List horarios) {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  for (int i = 0; i < horarios.length; i++) {
    var reglas = horarios[i]['rRule'] ?? "";
    final splitted = reglas.split(':');

    if (splitted.length > 1) {
      print(splitted[1]);
      meetings.add(Meeting(
          horarios[i]['title']!,
          DateTime.parse(horarios[i]['startDate']),
          DateTime.parse(horarios[i]['endDate']),
          const Color(0xffffcc00),
          false,
          splitted[1]));
    } else {
      meetings.add(Meeting(
          horarios[i]['title']!,
          DateTime.parse(horarios[i]['startDate']),
          DateTime.parse(horarios[i]['endDate']),
          const Color(0xffffcc00),
          false,
          ""));
    }
  }

  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false, ""));
  return meetings;
}

Widget _buildComposer() {
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
    child: Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              offset: const Offset(4, 4),
              blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
          color: AppTheme.white,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            child: TextField(
              maxLines: null,
              onChanged: (String txt) {},
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 16,
                color: AppTheme.dark_grey,
              ),
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your feedback...'),
            ),
          ),
        ),
      ),
    ),
  );
}
