// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_google_location_picker/export.dart';
import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';
import 'package:flutter_google_location_picker/model/lat_lng_model.dart';
import 'package:untitled/NotificationService.dart';
import 'package:untitled/Slot.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Form.dart';
import 'GoogleMaps.dart';

// void main() {
//   runApp(MyApp());
// }

class MainPage extends StatefulWidget {
  List<Slot> slots;
  MainPage(this.slots);

  @override
  State<StatefulWidget> createState() {
    return MainPageState(slots);
  }
}

class MainPageState extends State<MainPage> {
  MainPageState(this.slots);

  List<Slot> slots = [];
  List<Slot> listToShow=[];
  var showForm = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void addToList(String title, DateTime date, LatLong location) {
    setState(() {
      slots.add(Slot(title, date, location));
    });
  }

  void buttonClicked() {
    setState(() {
      showForm = !showForm;
    });
  }
  void buttonMapClicked() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MapSample(slots)));
  }
  void buttonShowAll() {
    setState(() {
      _selectedDay= null;
      listToShow = slots;
    });
  }

  void showSlots(){
    listToShow=[];
      for (var s in slots) {
        if (s.dateTime.year == _selectedDay?.year &&
            s.dateTime.month == _selectedDay?.month &&
            s.dateTime.day == _selectedDay?.day) {
          listToShow.add(s);
        }
      }
      if (_selectedDay==null) {
        listToShow = slots;
      }
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
            appBar: AppBar(
              title: Text("Hello"),
              actions: <Widget>[
                IconButton(onPressed: buttonClicked, icon: Icon(Icons.add)),
                IconButton(onPressed: buttonMapClicked, icon: Icon(Icons.map)),
                IconButton(onPressed: buttonShowAll, icon: Icon(Icons.all_inbox))
              ],
            ),
            body:
            Column(
              children: [
                showForm ? MyCustomForm(addToList) : const SizedBox.shrink(),
                TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        showSlots();
                      });
                    }
                  },
                ),
                slots.isEmpty
                    ? Text("No slots")
                    : Expanded(
                        child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(listToShow[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(listToShow[index].dateTime.toString()),
                            ),
                          );
                        },
                        itemCount: listToShow.length,
                      )),
              ],
            )));
  }
}
