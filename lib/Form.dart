import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_location_picker/export.dart';
import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';
import 'package:flutter_google_location_picker/model/lat_lng_model.dart';
import 'package:geolocator/geolocator.dart';

import 'NotificationService.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  final Function function;

  const MyCustomForm(this.function, {super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(this.function);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    _getCurrentPosition();
    super.initState();
  }
  MyCustomFormState(this.function);
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => curLocation = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }


    late final LocalNotificationService service;
  final _formKey = GlobalKey<FormState>();
  Function function;
  final Map<String, dynamic> formData = {'title': "", 'date': DateTime.now()};
  DateTime dateTime = DateTime.now();
  late LatLong _pickedLocation;
  late Position curLocation = Position(longitude: 22.4, latitude: 22.4, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);


  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      this.dateTime = dateTime;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (String? value) {
              formData['title'] = value ?? "";
            },
            decoration: InputDecoration(hintText: 'Enter Name'),
          ),
          ElevatedButton(
              onPressed: pickDateTime,
              child: Text(
                  '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes')),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            child: FlutterGoogleLocationPicker(
              showZoomButtons: true,
              center: LatLong(latitude: curLocation.latitude, longitude: curLocation.longitude),
              onPicked: (pickedData) {
                _pickedLocation=pickedData.latLong;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();
              function(formData['title'], dateTime, _pickedLocation);
              // await service.showNotification(id: 0, title: formData['title'], body: dateTime.toString());
              await service.showScheduledNotification(
                  id: 0,
                  title: formData['title'],
                  body: dateTime.toString(),
                  dateTime: dateTime);
            },
            child: const Text('Submit'),
          )
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}


