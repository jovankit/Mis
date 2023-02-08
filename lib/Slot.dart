import 'package:flutter_google_location_picker/model/lat_lng_model.dart';

class Slot{
  String name;
  DateTime dateTime;
  LatLong location;
  Slot(this.name, this.dateTime, this.location);
}