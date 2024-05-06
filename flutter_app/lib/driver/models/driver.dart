// ignore_for_file: non_constant_identifier_names

class Driver{
  final String firstname;
  final String lastname;
  final String SDT;
  final int Wallet;
  final String DOB;
  final String gender;
  final String Address;
  final String CCCD;
  final String Driving_license;
  final int Working_experiment;

  Driver({required this.firstname,required this.lastname,required this.SDT,required this.Wallet,required this.DOB,required this.gender,required this.Address,required this.CCCD, required this.Driving_license, required this.Working_experiment});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      firstname: json['firstname'],
      lastname: json['lastname'],
      SDT: json['SDT'],
      Wallet: json['Wallet'],
      DOB: json['DOB'],
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
      Driving_license: json['Driving_license'],
      Working_experiment: json['Working_experiment']
    );
  }

  Map<String, dynamic> toJson() {
    return {
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