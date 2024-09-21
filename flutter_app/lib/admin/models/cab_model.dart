class Cab {
  final String ID;
  final String licence_plate;

  Cab(this.ID, this.licence_plate);
}

class FullCab {
  final String ID;
  final String licence_plate;
  final String car_model_id;
  final String manufacture_year;
  final String active;
  final String model_name;
  final String model_description;

  FullCab(this.ID, this.licence_plate, this.car_model_id, this.manufacture_year,
      this.active, this.model_name, this.model_description);
}
