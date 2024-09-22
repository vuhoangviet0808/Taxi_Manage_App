// ignore_for_file: non_constant_identifier_names

class Driver {
  final String Firstname;
  final String Lastname;
  final String Driver_ID;

  Driver(this.Firstname, this.Lastname, this.Driver_ID);

  get driverId => null;

  get lastName => null;
}

class FullDriver {
  final String Firstname;
  final String Lastname;
  final String Driver_ID;
  final String SDT;
  final String Wallet;
  final String DOB;
  final String Gender;
  final String Address;
  final String CCCD;
  final String Driving_licence_number;
  final String Working_experiment;

  FullDriver(
    this.Firstname,
    this.Lastname,
    this.Driver_ID,
    this.SDT,
    this.Wallet,
    this.DOB,
    this.Gender,
    this.Address,
    this.CCCD,
    this.Driving_licence_number,
    this.Working_experiment,
  );
}
