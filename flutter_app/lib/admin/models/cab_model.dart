class Cab {
  final String ID;
  final String licence_plate;

  Cab(this.ID, this.licence_plate);
}

class FullCab {
  final String ID;
  final String licence_plate;
  final String car_type;
  final String manufacture_year;
  final String active;

  FullCab(this.ID, this.licence_plate, this.car_type, this.manufacture_year,
      this.active);
}
