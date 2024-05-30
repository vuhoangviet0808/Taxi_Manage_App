// ignore_for_file: non_constant_identifier_names

class User {
  int User_ID;
  String firstname;
  String lastname;
  String SDT;
  int Wallet;
  String DOB;
  String gender;
  String Address;
  String CCCD;

  User({
    required this.User_ID,
    required this.firstname,
    required this.lastname,
    required this.SDT,
    required this.Wallet,
    required this.DOB,
    required this.gender,
    required this.Address,
    required this.CCCD,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      User_ID: json['User_ID'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      SDT: json['SDT'],
      Wallet: json['Wallet'],
      DOB: json['DOB'],
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_ID': User_ID,
      'firstname': firstname,
      'lastname': lastname,
      'SDT': SDT,
      'Wallet': Wallet,
      'DOB': DOB,
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
    };
  }
}