// ignore_for_file: non_constant_identifier_names

class Driver {
  int Driver_ID;
  String firstname;
  String lastname;
  String SDT;
  int Wallet;
  String DOB;
  String gender;
  String Address;
  String CCCD;
  String Driving_license;
  int Working_experiment;

  Driver(
      {required this.Driver_ID,
      required this.firstname,
      required this.lastname,
      required this.SDT,
      required this.Wallet,
      required this.DOB,
      required this.gender,
      required this.Address,
      required this.CCCD,
      required this.Driving_license,
      required this.Working_experiment});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        Driver_ID: json['Driver_ID'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        SDT: json['SDT'],
        Wallet: json['Wallet'],
        DOB: json['DOB'],
        gender: json['gender'],
        Address: json['Address'],
        CCCD: json['CCCD'],
        Driving_license: json['Driving_license'],
        Working_experiment: json['Working_experiment']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Driver_ID': Driver_ID,
      'firstname': firstname,
      'lastname': lastname,
      'SDT': SDT,
      'Wallet': Wallet,
      'DOB': DOB,
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
      'Driving_license': Driving_license,
      'Working_experiment': Working_experiment
    };
  }
}
